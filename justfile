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
	ssh {{user}}@127.0.0.1 -p {{port}}

alias lint := format
alias f := format
[doc('Run all formatters')]
[group('run')]
format:
	nix fmt

alias c := clean
[doc('Remove file that stores the state of the VM')]
[group('run')]
clean:
	echo "Removing file that stores the state of the VM"
	rm -f adguard.qcow2

[doc('Build SD image')]
[group('build')]
build-image: clean
    echo "Building SD Image..."
    nixos-rebuild build-image --image-variant sd-card .#adguard-pi

[doc('Run all available tests')]
[group('test')]
test-all:
	nix flake check -L

[doc('Run a specific test')]
[group('test')]
test name arch="x86_64-linux":
	echo "Running test {{name}} for {{arch}}"
	nix run .#checks.{{arch}}.{{name}}.driver