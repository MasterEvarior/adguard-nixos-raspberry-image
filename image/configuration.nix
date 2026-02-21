{
  pkgs,
  imageConfig,
  ...
}:
{
  imports = [
    ./services
    ./settings
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    micro
  ];

  # Networking
  networking = {
    hostName = imageConfig.machine.hostname;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
