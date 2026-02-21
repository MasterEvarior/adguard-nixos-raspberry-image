start_all()

server.wait_for_unit("prometheus-smartctl-exporter.service")
server.wait_for_open_port(9633)

with subtest("Smartctl Exporter is reachable from server"):
    server.succeed("curl --fail http://127.0.0.1:9633/metrics")

with subtest("Smartctl Exporter is reachable from external client"):
    client.succeed("curl --fail http://server:9633/metrics")
