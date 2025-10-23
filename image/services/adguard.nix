{ ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    openFirewall = true;

    host = "0.0.0.0";
    port = 80;

    settings = {
      theme = "auto";
      users = [ ];
      querylog.enabled = false;
      statistics.enabled = true;
      dhcp.enabled = false;
      anonymize_client_ip = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
}
