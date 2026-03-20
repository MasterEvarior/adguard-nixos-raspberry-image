{
  lib,
  imageConfig,
  assertionLib,
  ...
}:
let
  # Config Aliases
  dnsPort = imageConfig.adguard.dns.port;
  upstreams = imageConfig.adguard.dns.upstreams;
  mode = imageConfig.adguard.dns.upstreamMode;
  statistics = imageConfig.adguard.statistics;
  bootstraps = imageConfig.adguard.dns.bootstraps;
  blockedServices = imageConfig.adguard.blockedServices;
  filters = imageConfig.adguard.filters;
  users = imageConfig.adguard.users;

  # Validation helpers
  inherit (assertionLib)
    isUrl
    isIp
    isNotBlank
    isNotEmpty
    isValidMode
    isPortNumber
    isValidTimespan
    areAllUsersValid
    ;

  processedFilters = lib.imap1 (index: value: {
    inherit (value) name url;
    id = index;
    enabled = true;
  }) filters;
  processedBlockedServices = map lib.toLower (builtins.filter isNotBlank blockedServices);
  processedUsers = if users != null then users else [ ];
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
    {
      assertion = isNotBlank mode;
      message = "Error: A mode for the upstream DNS needs to be specified";
    }
    {
      assertion = isValidMode mode;
      message = "Error: A the upstream DNS mode needs to be one of the valid specified choices";
    }
    {
      assertion = isPortNumber dnsPort;
      message = "Error: The DNS port needs to be a valid port number";
    }
    {
      assertion = builtins.isBool statistics.enable;
      message = "Error: statistics.enable needs to be a boolean value (true/false)";
    }
    {
      assertion = isValidTimespan statistics.interval;
      message = "Error: statistics.interval needs to be a valid timespan in hours that lasts between one hour and a year";
    }
    {
      assertion = (areAllUsersValid processedUsers);
      message = "Error: some of your users are invalid, see the documentation for more information about how a user should be structured";
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
      users = processedUsers;
      querylog.enabled = false;
      statistics = {
        enabled = statistics.enable;
        interval = statistics.interval;
      };
      dhcp.enabled = false;
      anonymize_client_ip = true;
      filters = processedFilters;
      filtering.blocked_services.ids = processedBlockedServices;
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = dnsPort;
        upstream_dns = upstreams;
        bootstrap_dns = bootstraps;
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      dnsPort
    ];
    allowedTCPPorts = [
      dnsPort
    ];
  };
}
