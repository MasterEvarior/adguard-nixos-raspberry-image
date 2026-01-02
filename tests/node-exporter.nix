{
  pkgs,
  modules ? [ ],
  ...
}:

let
  mkConnectionTest = host: "curl --fail http://${host}:9100/metrics";
in
pkgs.testers.runNixOSTest {
  name = "node-exporter";

  nodes = {

    server =
      { pkgs, lib, ... }:
      {
        imports = [
          ../image/configuration.nix
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

  testScript = ''
    start_all()

    server.wait_for_unit("prometheus-node-exporter.service")
    server.wait_for_open_port(9100)

    with subtest("Node Exporter is reachable from server"):
      server.succeed("${mkConnectionTest "127.0.0.1"}")

    with subtest("Node Exporter is reachable from external client"):
      client.succeed("${mkConnectionTest "server"}")
  '';

}
