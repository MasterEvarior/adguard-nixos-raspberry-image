[doc('List all available recipes')]
default:
    just --list

[doc('Start an interactive VM to debug and test')]
[group('run')]
run-vm:
	QEMU_OPTS="-snapshot" nix run .#test-vm

[doc('Connect to the interactive debug/test VM via SSH')]
[group('run')]
connect-vm user="stan" port="2222":
	@echo "Connecting via SSH with user {{user}} on port {{port}}"
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityAgent=none -i {{justfile_directory()}}/private_example_key -p {{port}} {{user}}@127.0.0.1

alias lint := format
alias f := format
[doc('Run all formatters')]
[group('lint')]
format:
	nix fmt

[doc('Check formatting')]
[group('lint')]
format-check:
	nix fmt -- --fail-on-change

[doc('Build SD image')]
[group('build')]
build-image: clean
    @echo "Building SD Image..."
    nix build .#nixosConfigurations.adguard-pi.config.system.build.sdImage

alias c := clean
[doc('Remove file that stores the state of the VM')]
[group('maintenance')]
clean:
	@echo "Removing file that stores the state of the VM"
	rm -f adguard.qcow2

alias u := update
[doc('Update flake')]
[group('maintenance')]
update:
    nix flake update
    @echo "Running tests to check whether update works..."
    just test-all
    @echo "Tests passed. Committing changes..."
    git add flake.lock
    git commit -m "chore(deps): update flake.lock"

[doc('Run all available tests')]
[group('test')]
test-all:
	nix flake check -L

[doc('Run a specific test')]
[group('test')]
test name arch="x86_64-linux":
	@echo "Running test {{name}} for {{arch}}"
	nix run .#checks.{{arch}}.{{name}}.driver