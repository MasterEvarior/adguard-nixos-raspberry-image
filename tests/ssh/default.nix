{
  pkgs,
  modules ? [ ],
  ...
}:

pkgs.testers.runNixOSTest {
  name = "ssh";

  nodes = {

    server =
      {
        pkgs,
        lib,
        imageConfig,
        ...
      }:
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

        # Override the public key of the user for the test
        users.users.${imageConfig.user.username}.openssh.authorizedKeys.keys = lib.mkForce [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9BiQKu8SmL8zn+9Js1irnjbEXjhFuDnqppRjllJXjv noname"
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
