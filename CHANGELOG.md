## [1.1.0] - 2026-02-23

### 🚀 Features

- Add ability to specify upstream DNS mode

### 📚 Documentation

- Improve README.md
- Fix typo
- Clarify generated image format

## [1.0.0] - 2026-02-21

### 🚀 Features

- Enable diskstats and filesystem collectors
- Add possibility add bootstrap and upstream DNS servers
- Add assertions for adguard configuration
- Add assertions for user settings

### 📚 Documentation

- Add documentation for new settings

## [0.3.0] - 2026-02-21

### 🚀 Features

- Update default settings

### 🧪 Testing

- Add test for blocked services

### ⚙️ Miscellaneous Tasks

- Format files
- Add action to automatically create a release on a new tag
- Run linter

## [0.2.0] - 2026-02-20

### 🚀 Features

- Remove compression from .img file
- Readd image compression
- Enable support for blocked services

### 🐛 Bug Fixes

- Allow passwordless user to use sudo

### 🚜 Refactor

- Remove dead code

### 📚 Documentation

- Add links to tools
- Add note about image decompression

## [0.1.1] - 2026-02-17

### ⚙️ Miscellaneous Tasks

- Run formatter
- Add test to check wether the image still builds
- Add deadnix
- Add QEMU binaries and aarch64-linux platform
- Only run intensive jobs after lint passes
- Add names to jobs
- *(just)* Fix release command

## [0.1.0] - 2026-02-16

### 🚀 Features

- Add adguard and some settings into a modular structure
- Add a rudimentary config process
- Customize agh a bit more
- Add node exporter service
- Add just as a commandline runner to make life easier
- Add package to build sd image
- Add possibility to add filters to adguard
- Add working SSH service with tests
- Add possibility to remove password from the user
- Add possibility to use custom config
- Make SSH debugging work

### 🐛 Bug Fixes

- Make tests and image build work both at the same time

### 🚜 Refactor

- Mode config module into a let definition
- Move port forwarding to a separate module
- Add helper function for port forwarding
- Remove TOML config
- Rename vmConfig
- Move adguard settings into a separate set
- Remove dependency on deprecated nix-generators
- Add base modules

### 📚 Documentation

- Add more references to README.md
- Add some basic content to the README.md
- Improve README.md
- Remove references to TOML file, add maintenance section
- Remove unused file

### 🧪 Testing

- Move test to separate file
- Add tests for AdGuard filters
- Move test scripts to python files
- Add -L flag to test execution
- Fix ssh test

### ⚙️ Miscellaneous Tasks

- Init project
- Add .gitignore
- Add more files to .gitignore
- Do stuff
- Add treefmt
- Run formatter
- Add formatter into justfile
- Add just command to clean output
- Add linting and tests action
- Add renovate config
- Format files
- Add YAML linter
- Add --impure fix for CI
- Add TODOs
- Format files
- Remove impure evalution from ci
- Update TODOs
- Add command to connect via SSH
- Remove magic nix cache
- *(just)* Add update command
- *(just)* Replace echo with @echo
- Add renovate config
- *(just)* Add command to check linting
- Use correct lint command in workflow
- Add basic release management
