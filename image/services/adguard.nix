{ lib, imageConfig, ... }:
let
  # Config Aliases
  upstreams = imageConfig.adguard.dns.upstreams;
  bootstraps = imageConfig.adguard.dns.bootstraps;
  blockedServices = imageConfig.adguard.blockedServices;
  filters = imageConfig.adguard.filters;

  # Validation helpers
  isUrl = s: builtins.match "^http(s)?:\/\/.+$" s != null;
  isIPv4 = s: builtins.match "^([0-9]{1,3}\.){3}[0-9]{1,3}$" s != null;
  isIPv6 = s: builtins.match "^[0-9a-fA-F]*:[0-9a-fA-F:]+$" s != null;
  isIp = s: isIPv4 s || isIPv6 s;
  isNotBlank = s: s != null && (lib.trim s) != "";
  isNotEmpty = l: builtins.length l != 0;

  processedFilters = lib.imap1 (index: value: {
    inherit (value) name url;
    id = index;
    enabled = true;
  }) filters;
  processedBlockedServices = map lib.toLower (builtins.filter isNotBlank blockedServices);
in
{
  assertions = [
    {
      assertion = builtins.all isUrl upstreams;
      message = "Error: All upstream DNS entries must be URLs (e.g., starting with https://, tls://, etc.). Check your settings.nix.";
    }
    {
      assertion = builtins.all isIp bootstraps;
      message = "Error: All bootstrap DNS entries must be valid IP addresses (IPv4 or IPv6). Check your settings.nix.";
    }
    {
      assertion = builtins.all (filter: isUrl filter.url) filters;
      message = "Error: All filter URLs must be valid URLs. Check the adguard.filters list in your settings.nix.";
    }
    {
      assertion = builtins.all isNotBlank blockedServices;
      message = "Error: Blocked services cannot be empty";
    }
    {
      assertion = isNotEmpty upstreams;
      message = "Error: At least one upstream DNS needs to be defined";
    }
    {
      assertion = isNotEmpty bootstraps;
      message = "Error: At least one bootstrap DNS needs to be defined";
    }
  ];

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
      dns = {
        upstream_dns = upstreams;
        bootstrap_dns = bootstraps;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
}
