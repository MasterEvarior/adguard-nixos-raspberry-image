start_all()

server.wait_for_unit("prometheus-node-exporter.service")
server.wait_for_open_port(9100)

with subtest("Node Exporter is reachable from server"):
    server.succeed("curl --fail http://127.0.0.1:9100/metrics")

with subtest("Node Exporter is reachable from external client"):
    client.succeed("curl --fail http://server:9100/metrics")
