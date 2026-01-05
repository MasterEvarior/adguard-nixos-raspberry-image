{ ... }:
{
  virtualisation.forwardPorts = [
    {
      from = "host";
      host.address = "127.0.0.1";
      host.port = 8080;
      guest.port = 80;
    }
    {
      from = "host";
      host.address = "127.0.0.1";
      host.port = 9100;
      guest.port = 9100;
    }
  ];
}
