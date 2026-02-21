{
  pkgs,
  modules ? [ ],
  ...
}:

pkgs.testers.runNixOSTest {
  name = "smartctl-exporter";

  nodes = {

    server =
      { pkgs, lib, ... }:
      {
        imports = [
          ../../image/configuration.nix
        ]
        ++ modules;

        networking.hostName = lib.mkForce "server";

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

  testScript = builtins.readFile ./script.py;

}
