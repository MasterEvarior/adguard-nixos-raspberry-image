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
      packages.x86_64-linux = {
        run-vm = nixos-generators.nixosGenerate {
          modules = [
            ./image/configuration.nix
            configModule
          ];

          system = "x86_64-linux";
          format = "vm";
        };
      };
    };
}
