is_ci := env_var_or_default("CI", "false")
flags := if is_ci == "true" { "--impure" } else { "" }

[doc('List all available recipes')]
default:
    just --list

[doc('Start an interactive VM to debug and test')]
[group('run')]
run-vm:
	rm -rf ./result && rm -f adguard.qcow2
	nix build .#run-vm
	./result/bin/run-adguard-vm

alias lint := format
alias f := format
[doc('Run all formatters')]
[group('run')]
format:
	nix fmt {{flags}}

alias c := clean
[doc('Remove file that stores the state of the VM')]
[group('run')]
clean:
	echo "Removing file that stores the state of the VM"
	rm -f adguard.qcow2

default_config := "config.toml"
[doc('Build SD image')]
[group('build')]
build-image: clean
    echo "Building SD Image..."
    nix build .#sd-image

[doc('Run all available tests')]
[group('test')]
test-all:
	nix flake check {{flags}} -L

[doc('Run a specific test')]
[group('test')]
test name arch="x86_64-linux":
	echo "Running test {{name}} for {{arch}}"
	nix run .#checks.{{arch}}.{{name}}.driver