{
  pkgs,
  imageConfig,
  assertionLib,
  ...
}:
let
  # Config Aliases
  hostName = imageConfig.machine.hostname;

  # Validation helpers
  inherit (assertionLib)
    mkNotBlank
    ;
in
{
  assertions = [
    (mkNotBlank "hostname" hostName)
  ];

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
    inherit hostName;
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
