{ ... }:

let
  mkSameForward = port: (mkForward port port);
  mkForward = hostPort: guestPort: {
    from = "host";
    host = {
      address = "127.0.0.1";
      port = hostPort;
    };
    guest.port = guestPort;
  };
in
{
  virtualisation.forwardPorts = [
    (mkForward 2222 22) # SSH
    (mkForward 8080 80) # AdGuard
    (mkSameForward 9100) # Node Exporter
  ];
}
