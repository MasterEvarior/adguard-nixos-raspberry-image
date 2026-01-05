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

  users.users.${vmConfig.user.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = vmConfig.user.initial_password;
    openssh.authorizedKeys.keys = [ vmConfig.user.ssh_key ];
  };

  # Networking
  networking = {
    hostName = vmConfig.machine.hostname;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
