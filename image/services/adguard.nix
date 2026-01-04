{ lib, vmConfig, ... }:
let
  processedFilters = lib.imap1 (index: value: {
    inherit (value) name url;
    id = index;
    enabled = true;
  }) vmConfig.filters;
in
{
  options = {
    filters = lib.mkOption {
      default = vmConfig.filters;
      example = {
        name = "AdAway Blocklist";
        url = "https://adaway.org/hosts.txt";
      };
      type = lib.types.listOf (
        lib.types.submodule {
          name = lib.mkOption { type = lib.types.str; };
          url = lib.mkOption { type = lib.types.str; };
        }
      );
      description = "List of filters to add to the AdGuard configuration";
    };
  };

  config = {
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
  };
}
