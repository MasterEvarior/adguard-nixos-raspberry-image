pkgs.testers.runNixOSTest {

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

}
