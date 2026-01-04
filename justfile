[doc('List all available recipes')]
default:
    just --list

[doc('Start an interactive VM to debug and test')]
[group('run')]
run-vm:
	rm -rf ./result && rm -f adguard.qcow2
	nix build .#run-vm
	./result/bin/run-adguard-vm

alias b := build-image
[doc('Build SD image')]
[group('build')]
build-image:
	rm -rf ./result && rm -f adguard.qcow2
	nix build .#sd-image

[doc('Run all available tests')]
[group('test')]
test-all:
	nix flake check

[doc('Run a specific test')]
[group('test')]
test name arch="x86_64-linux":
	echo "Running test {{name}} for {{arch}}"
	nix run .#checks.{{arch}}.{{name}}.driver

[doc('Run linter(s)')]
[group('lint')]
lint:
	nix fmt