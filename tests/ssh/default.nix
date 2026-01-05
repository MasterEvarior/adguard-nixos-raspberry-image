{
  pkgs,
  modules ? [ ],
  ...
}:

pkgs.testers.runNixOSTest {
  name = "ssh";

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
        environment.systemPackages = [
          pkgs.curlMinimal
          pkgs.netcat
        ];
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curlMinimal
          pkgs.netcat
          pkgs.openssh
        ];

        environment.etc."id_ed25519" = {
          source = ./private-key.txt;
          mode = "0600";
        };

        virtualisation.graphics = false;
      };

  };

  testScript = builtins.readFile ./script.py;
}
