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
        ];
      };

      packages.${system} = {
        run-vm = nixos-generators.nixosGenerate {
          modules = [
            ./image/configuration.nix
            configModule
          ];

          system = system;
          format = "vm";
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
