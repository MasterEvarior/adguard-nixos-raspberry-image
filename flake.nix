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

      checks.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.pkgs.testers.runNixOSTest {
        name = "adguard";
        nodes = {

          server =
            { pkgs, ... }:
            {
              imports = [
                ../image/configuration.nix
              ];

              virtualisation.graphics = false;
              environment.systemPackages = [ pkgs.curlMinimal ];
            };

          client =
            { pkgs, ... }:
            {
              environment.systemPackages = [ pkgs.curlMinimal ];
              virtualisation.graphics = false;
            };

        };

        testScript = ''
          start_all()

          server.wait_for_unit("adguardhome.service")
          server.wait_for_open_port(53)
          server.wait_for_open_port(80)

          with subtest("AdGuard Home is reachable from server"):
            server.succeed("curl --fail http://127.0.0.1:80 | grep -q '<title>AdGuard Home</title>'")

          with subtest("AdGuard Home is reachable from client"):
            server.succeed("curl --fail http://server:80 | grep -q '<title>AdGuard Home</title>'")
        '';

      };
    };
}
