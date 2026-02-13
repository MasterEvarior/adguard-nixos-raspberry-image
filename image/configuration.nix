{
  pkgs,
  vmConfig,
  ...
}:
let
  initialPassword = if vmConfig.user.noPassword then null else vmConfig.user.initialPassword;
in
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
    inherit initialPassword;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ vmConfig.user.sshKey ];
  };

  # Networking
  networking = {
    hostName = vmConfig.machine.hostname;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
