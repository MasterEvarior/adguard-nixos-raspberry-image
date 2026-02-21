import json

start_all()

server.wait_for_unit("adguardhome.service")
server.wait_for_open_port(53)
server.wait_for_open_port(80)

with subtest("AdGuard Home is reachable from server"):
    server.succeed(
        "curl --fail http://127.0.0.1:80 | grep -q '<title>AdGuard Home</title>'"
    )

with subtest("AdGuard Home has loaded specified lists via API"):
    response = server.succeed(
        "curl -s http://127.0.0.1:80/control/filtering/status"
    ).strip()
    data = json.loads(response)

    filter_names = [f["name"] for f in data.get("filters", [])]

    expected_filters = ["URL House", "AdAway Default Blocklist"]
    for name in expected_filters:
        if name in filter_names:
            server.log(f"Verified filter: {name}")
        else:
            server.fail(f"Filter '{name}' not found in AdGuard. Found: {filter_names}")

with subtest("AdGuard Home has blocked specified services"):
    response = server.succeed(
        "curl -s http://127.0.0.1:80/control/blocked_services/get"
    ).strip()

    data = json.loads(response)

    service_names = data.get("ids", [])

    expected_services = ["facebook", "betano", "betfair", "blaze", "betway", "shein"]
    for name in expected_services:
        if name in service_names:
            server.log(f"Verified blocked service: {name}")
        else:
            server.fail(
                f"Service '{name}' not found in AdGuard. Found: {service_names}"
            )

with subtest("AdGuard Home is reachable from client"):
    client.succeed(
        "curl --fail http://server:80 | grep -q '<title>AdGuard Home</title>'"
    )
