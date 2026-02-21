# AdGuard Home NixOS Raspberry Pi Image

A custom, reproducible NixOS image builder for Raspberry Pi (AArch64) pre-configured with AdGuard Home, Prometheus Node Exporter and SSH.

This project uses **Nix Flakes** to create ready-to-flash SD card images defined entirely by code and some `.nix` files.

## Features & Services

The image comes pre-loaded with the following services. Configuration is handled automatically via the build process.

### AdGuard Home

- **Port:** `80` (Web Interface), `53` (DNS)
- **Description:** Network-wide software for blocking ads and tracking.
- **Configuration:**
  - Pre-configured with blocklists defined in `settings.nix`
  - Anonymized client IPs by default
  - DHCP disabled (can be enabled in UI)
  - Mutable settings: You can change settings in the UI after flashing, and they will persist

### Node Exporter (Prometheus)

- **Port:** `9100`
- **Description:** Exposes hardware and OS metrics (CPU, RAM, Disk) for Prometheus
- **Note:** The endpoint is exposed on the local network without authentication!

### SSH

- **Port:** `22`
- **Authentication:** Public Key only. Password authentication is disabled for security reasons
- **User:** Defined in the `settings.nix` file

## Configuration

The entire image is configured using the `settings.nix` file. You can copy the example to get started:

### Configuration Options

- `machine.hostname`: The network hostname for the Pi
- `user.username`: The name of the primary user account
- `user.no_password`: Set to true to disable password login entirely (recommended)\`
- `user.ssh_key`: Required. Your public SSH key (e.g. contents of `~/.ssh/id_ed25519.pub`)
- `adguard.filters.<entry>.name`: Display name in AdGuard
- `adguard.filters.<entry>.url`: The URL to the hosts or blocklist file
- `adguard.blockedServices`: List of services to enable on the "Filters -> Blocked Services" page
- `adguard.dns.upstreams`: List of upstream DNS endpoints to use, needs to be a valid URL
- `adguard.dns.bootstraps`: List of IP addresses to initially resolve the upstream DNS endpoints

You can define multiple blocklists. These are downloaded by AdGuard on the first boot. The AdGuard configuration is mutable, so it can be changed after the deployment via the GUI.

## Usage & Building

This project uses [just](https://github.com/casey/just) as a command runner.
Prerequisites

- Nix installed with Flakes enabled
- Just (optional, but makes commands easier)
- Direnv (optiona, but makes life easier)

Run `just` to see all available commands.

### 1. Build the SD Image

To build the actual `.img` file for a Raspberry Pi (AArch64), run:

```shell
just build-image
```

This will produce a `.img` file in `result/sd-image`.

### 2. Flash to SD Card

You can use tools like [Belana Etcher](https://etcher.balena.io/), [rpi-imager](https://github.com/raspberrypi/rpi-imager/) or standard `dd`:

> [!CAUTION]\
> Be CAREFUL with dd. It can destroy your entire installation.\
> Replace /dev/sdX with your actual SD card device.

If you use `dd`, the compressed image will need to be decompressed first:

```shell
cp ./result/sd-nixos-image-sd-card-*.zst ./image.img.zst
zstd ./image.img.zst --decompress
```

Afterwards, `dd` can be used to flash the image onto your SD card.

```shell
sudo dd if=./image.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## Development & Testing

You can test the configuration in a local Virtual Machine before deploying to hardware.
Run in a VM

This compiles the configuration for x86_64 and boots it in QEMU.

```shell
just run-vm
```

Port Forwarding: When running in the VM, ports are mapped to the host machine:

- AdGuard Web: https://www.google.com/search?q=http://127.0.0.1:8080
- Node Exporter: https://www.google.com/search?q=http://127.0.0.1:9100
- SSH: `ssh -p 2222 <user>@127.0.0.1`

The port-forwarding can be configured in the `port-forwarding.nix` file.

You can connect to the VM over SSH using this command:

```shell
just connect-vm

# or with a custom user and port
just connect myuser 1234
```

### Tests

This project includes NixOS integration tests to ensure services start correctly.

```shell
# Run all tests
just test-all

# Run a specific test
just test adguard
just test ssh
just test node-exporter
just test ...
```

### Linting

This project includes linting with treefmt.

```shell
just format
```

## Maintenance

To update the `flake.lock`file, execute the following command:

```shell
just update
```

This will:

- Update the `flake.lock` file
- Run all tests
- Create a new commit if the tests where successful

To release a new version, simply run this command:

```shell
just release
```

This will create a new commit, with an updated `CHANGELOG.md`.

## References

- [How (and why) to build minimal and reproducible Docker images with Nix](https://github.com/zimbatm/vm-image-nix-talk)
- [NixOS Series: Making Custom VPS Images for the Cloud](https://crystalwobsite.gay/posts/2025-01-26-nixos_vm_image#writing-a-basic-configuration)
- [NixOS virtual machines](https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html#)
- [nixos-generators - one config, multiple formats](https://github.com/nix-community/nixos-generators)
- [How to use NixOS testing framework with flakes](https://blog.thalheim.io/2023/01/08/how-to-use-nixos-testing-framework-with-flakes/)
- [Writing your own Nix Flake checks](https://msfjarvis.dev/posts/writing-your-own-nix-flake-checks/)
