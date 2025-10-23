{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
    }:
    let
      lib = nixpkgs.lib;
    in
    {
      packages.x86_64-linux = {
        run-vm = nixos-generators.nixosGenerate {
          modules = [
            ./image/configuration.nix
          ];

          system = "x86_64-linux";
          format = "vm";
        };
      };
    };
}
