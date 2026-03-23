{
  imageConfig,
  assertionLib,
  ...
}:
let
  # Config Aliases
  initialPassword = if imageConfig.user.noPassword then null else imageConfig.user.initialPassword;
  username = imageConfig.user.username;
  sshKey = imageConfig.user.sshKey;

  # Validation helpers
  inherit (assertionLib)
    isNotBlank
    mkNotBlank
    ;
in
{
  assertions = [
    (mkNotBlank "username" username)
    {
      assertion = (isNotBlank sshKey) || (isNotBlank initialPassword);
      message = "Error: Either SSH key or initial password needs to be defined";
    }
  ];

  users.users.${username} = {
    inherit initialPassword;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ sshKey ];
  };

  # Disable password requirement for user if not password was set
  security.sudo.wheelNeedsPassword = if initialPassword == null then false else true;
}
