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
	nix fmt

alias c := clean
[doc('Remove file that stores the state of the VM')]
[group('run')]
clean:
	echo "Removing file that stores the state of the VM"
	rm -f adguard.qcow2

default_config := "config.toml"
[doc('Build SD image')]
[group('build')]
build-image config_path=default_config: clean
    #!/usr/bin/env bash
    set -e
    
    if [ ! -f "{{ config_path }}" ]; then
        echo "Error: Configuration file '{{ config_path }}' not found."
        exit 1
    fi

    ABS_PATH=$(realpath "{{ config_path }}")
    LINK_NAME="result-$(basename "{{ config_path }}" .toml)"

    echo "Building SD Image..."
    echo "Config: $ABS_PATH"

    nix build .#sd-image \
        --override-input tomlConfig "path:$ABS_PATH"

[doc('Run all available tests')]
[group('test')]
test-all:
	nix flake check

[doc('Run a specific test')]
[group('test')]
test name arch="x86_64-linux":
	echo "Running test {{name}} for {{arch}}"
	nix run .#checks.{{arch}}.{{name}}.driver