{
  pkgs,
  imageConfig,
  ...
}:
let
  initialPassword = if imageConfig.user.noPassword then null else imageConfig.user.initialPassword;
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

  users.users.${imageConfig.user.username} = {
    inherit initialPassword;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ imageConfig.user.sshKey ];
  };

  # Disable password requirement for user if not password was set
  security.sudo.wheelNeedsPassword = if initialPassword == null then false else true;

  # Networking
  networking = {
    hostName = imageConfig.machine.hostname;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
