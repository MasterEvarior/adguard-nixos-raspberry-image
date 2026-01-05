start_all()

server.wait_for_unit("sshd.service")
server.wait_for_open_port(22)

with subtest("Port 22 is reachable from server"):
    server.succeed("nc -zv 127.0.0.1 22")

with subtest("Port 22 is reachable from external client"):
    client.succeed("nc -zv server 22")

with subtest("SSH Connection established from external client"):
    client.succeed(
        "ssh -i /etc/id_ed25519 "
        "-o StrictHostKeyChecking=no "
        "-o UserKnownHostsFile=/dev/null "
        "stan@server 'echo SSH connection successful'"
    )
