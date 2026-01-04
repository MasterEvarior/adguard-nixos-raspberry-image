{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tomlConfig = {
      url = "path:./example-config.toml";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
      tomlConfig,
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      configModule = (
        {
          ...
        }:
        {
          _module.args.vmConfig = (lib.importTOML tomlConfig);
        }
      );
      portForwardModule = (
        { ... }:
        {
          virtualisation.forwardPorts = [
            {
              from = "host";
              host.address = "127.0.0.1";
              host.port = 8080;
              guest.port = 80;
            }
            {
              from = "host";
              host.address = "127.0.0.1";
              host.port = 9100;
              guest.port = 9100;
            }
          ];
        }
      );
    in
    {
      nixosModules = {
        adguardhome = (import ./image/services/adguard.nix);
        ssh = (import ./image/services/ssh.nix);
        nodeExporter = (import ./image/services/node-exporter.nix);
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          just
          coreutils # provides dd
        ];
      };

      packages.${system} = {
        run-vm = nixos-generators.nixosGenerate {
          modules = [
            ./image/configuration.nix
            configModule
            portForwardModule
          ];

          system = system;
          format = "vm";
        };

        sd-image = nixos-generators.nixosGenerate {
          modules = [
            ./image/configuration.nix
            configModule
          ];
          system = "aarch64-linux";
          format = "sd-aarch64";
        };
      };

      checks.${system} = {
        adguard = import ./tests/adguard.nix {
          inherit pkgs;
          modules = [ configModule ];
        };
        node-exporter = import ./tests/node-exporter.nix {
          inherit pkgs;
          modules = [ configModule ];
        };
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
