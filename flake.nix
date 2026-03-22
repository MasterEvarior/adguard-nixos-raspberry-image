{
  description = "Build an OS image for the Raspberry PI with AdGuard Home pre-installed";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      imageConfig = (import ./settings.nix);
      configModule = {
        _module.args = {
          inherit imageConfig;
          assertionLib = import ./lib/assertions.nix { inherit lib; };
        };
      };
      baseModules = [
        configModule
        ./image/configuration.nix
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          just
          coreutils # provides dd
          curl
          zstd
          mkpasswd

          # Releases
          git-cliff
          jq
        ];
      };

      nixosConfigurations = {
        adguard-pi = lib.nixosSystem {
          system = "aarch64-linux";
          modules = baseModules ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];
        };
        test-vm = lib.nixosSystem {
          inherit system;
          modules = baseModules ++ [
            "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
            ./port-forwarding.nix
          ];
        };
      };

      apps.${system} = {
        default = self.apps.${system}.test-vm;
        test-vm = {
          type = "app";
          meta.description = "Start a small VM to make debugging/testing easier";
          program = "${self.outputs.nixosConfigurations.test-vm.config.system.build.vm}/bin/run-${imageConfig.machine.hostname}-vm";
        };
      };

      checks.${system} = {
        adguard = import ./tests/adguard {
          inherit pkgs;
          modules = [
            configModule
          ];
        };

        node-exporter = import ./tests/node-exporter {
          inherit pkgs;
          modules = [
            configModule
          ];
        };

        ssh = import ./tests/ssh {
          inherit pkgs;
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            configModule
          ];
        };

        formatting = treefmtEval.config.build.check self;
      };

      formatter.${system} = treefmtEval.config.build.wrapper;
    };
}
