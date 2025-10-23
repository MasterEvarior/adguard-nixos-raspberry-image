{ ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    openFirewall = true;

    host = "0.0.0.0";
    port = 3000;

    settings = {
      theme = "auto";
      users = [ ];
    };
  };
}
