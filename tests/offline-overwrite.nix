{ lib, imageConfig, ... }:
{
  # Because tests do not have network access, we run into timeouts and the tests fail.
  # This simply should make it fail faster.
  services.adguardhome.settings.dns.upstream_dns = lib.mkForce [ "127.0.0.1" ];
  services.adguardhome.settings.dns.bootstrap_dns = lib.mkForce [ "127.0.0.1" ];
  services.adguardhome.settings.filters = lib.mkForce (
    lib.imap1 (index: value: {
      inherit (value) name url;
      id = index;
      enabled = false;
    }) imageConfig.adguard.filters
  );
}
