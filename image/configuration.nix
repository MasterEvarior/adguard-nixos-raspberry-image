{ pkgs, ... }:
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

  # TODO: remove this
  virtualisation.forwardPorts = [
    {
      from = "host";
      host.address = "127.0.0.1";
      host.port = 8080;
      guest.port = 3000;
    }
  ];

  # TODO: change this
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test123";
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Do not change this, not even for upgrades!
  system.stateVersion = "25.05";
}
