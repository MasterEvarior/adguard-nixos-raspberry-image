{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  i18n.defaultLocale = "de_CH.UTF-8";

  environment.systemPackages = with pkgs; [
    micro
  ];

  networking = {
    hostName = "nixos"; # NOTE: Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "Europe/Zurich";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [
    22
  ];

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
