{
  pkgs,
  vmConfig,
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

  virtualisation.forwardPorts = [
    {
      from = "host";
      host.address = "127.0.0.1";
      host.port = 8080;
      guest.port = 80;
    }
  ];

  users.users.${vmConfig.user.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = vmConfig.user.initial_password;
  };

  # Networking
  networking = {
    hostName = vmConfig.machine.hostname;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
