{ lib, imageConfig, ... }:
let
  processedFilters = lib.imap1 (index: value: {
    inherit (value) name url;
    id = index;
    enabled = true;
  }) imageConfig.adguard.filters;
  isNotEmpty = s: s != null && (lib.trim s) != "";
  processedBlockedServices = map lib.toLower (
    builtins.filter isNotEmpty imageConfig.adguard.blockedServices
  );
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
      filtering.blocked_services.ids = processedBlockedServices;
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
}
