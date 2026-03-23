{ lib }:

rec {
  # Validations

  isPortNumber = p: builtins.isInt p && p != null && p >= 1 && p <= 64738;
  isUrl = s: builtins.match "^http(s)?://.+$" s != null;
  isIPv4 = s: builtins.match "^([0-9]{1,3}\\.){3}[0-9]{1,3}$" s != null;
  isIPv6 = s: builtins.match "^[0-9a-fA-F]*:[0-9a-fA-F:]+$" s != null;
  isIp = s: isIPv4 s || isIPv6 s;
  isNotBlank = s: s != null && (lib.trim s) != "";
  isNotEmpty = l: builtins.length l != 0;
  isValidMode =
    m:
    lib.assertOneOf "upstreamMode" m [
      "load_balance"
      "parallel"
      "fastest_addr"
    ];
  isValidTimespan =
    s:
    let
      m = builtins.match "^([0-9]{1,4})h$" s;
      hours = lib.toInt (builtins.head m);
    in
    isNotBlank s && m != null && hours > 0 && hours <= 8760;
  isValidUsername = n: builtins.isString n && isNotBlank n;
  isValidPassword =
    p: builtins.isString p && isNotBlank p && builtins.match "\\$2[ayb]\\$[0-9]{1,2}\\$.+" p != null;
  isValidUser = u: isValidUsername u.name && isValidPassword u.password;
  areAllUsersValid = ul: builtins.all isValidUser ul;

  # Assertion Shortcuts
  mkNotEmpty = n: l: {
    assertion = isNotEmpty l;
    message = "Error: At least one ${n} needs to be defined";
  };
  mkIsBool = n: b: {
    assertion = builtins.isBool b;
    message = "Error: ${n} needs to be a boolean value (true/false)";
  };
}
