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
  mkForwardUDP = hostPort: guestPort: (mkForward hostPort guestPort) // { proto = "udp"; };
in
{
  virtualisation.forwardPorts = [
    (mkForward 2222 22) # SSH
    (mkSameForward 9100) # Node Exporter

    (mkForward 8080 80) # AdGuard
    (mkForwardUDP 5300 53) # DNS (UDP)
    (mkForward 5300 53) # DNS (TCP)
  ];
}
