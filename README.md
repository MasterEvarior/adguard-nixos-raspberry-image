# AdGuard Home NixOS Raspberry Pi Image

️⚠️ Currently in the works ⚠️

## Services

Multiple services are configured in the `./image/services` directory. Each of these is enabled and serves a specific purpose.

### AdGuard

[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) describes itself like this:

> AdGuard Home is a network-wide software for blocking ads and tracking. After you set it up, it'll cover ALL your home devices, and you don't need any client-side software for that.

This installation sets up a couple of default settings but otherwise leaves all the defaults and also the configuration mutable.

### Node Exporter (Prometheus)

[Node exporter](https://github.com/prometheus/node_exporter) describes itself like this:

> Prometheus exporter for hardware and OS metrics exposed by \*NIX kernels, written in Go with pluggable metric collectors.

This makes it possible to implement a simple health monitoring over the network.\
⚠️ Be aware that the endpoint is available without any authentication. ⚠️

### SSH

️⚠️ Currently in the works ⚠️

## OS Settings

All OS settings are in modules in the `./image/settings` directory.

## Configuration

️⚠️ Currently in the works ⚠️

## Links, References & more

- https://github.com/zimbatm/vm-image-nix-talk
- https://crystalwobsite.gay/posts/2025-01-26-nixos_vm_image#writing-a-basic-configuration.nix-for-our-vm-image
- https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html#

### Generators

- https://github.com/nix-community/nixos-generators

### Testing

- https://blog.thalheim.io/2023/01/08/how-to-use-nixos-testing-framework-with-flakes/
- https://msfjarvis.dev/posts/writing-your-own-nix-flake-checks/
