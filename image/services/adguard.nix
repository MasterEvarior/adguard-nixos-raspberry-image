{ lib, imageConfig, ... }:
let
  processedFilters = lib.imap1 (index: value: {
    inherit (value) name url;
    id = index;
    enabled = true;
  }) imageConfig.adguard.filters;
in
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
      filters = processedFilters;
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
}
