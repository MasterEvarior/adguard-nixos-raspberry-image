{ lib }:

rec {
  isUrl = s: builtins.match "^http(s)?://.+$" s != null;
  isIPv4 = s: builtins.match "^([0-9]{1,3}\\.){3}[0-9]{1,3}$" s != null;
  isIPv6 = s: builtins.match "^[0-9a-fA-F]*:[0-9a-fA-F:]+$" s != null;
  isIp = s: isIPv4 s || isIPv6 s;
  isNotBlank = s: s != null && (lib.trim s) != "";
  isNotEmpty = l: builtins.length l != 0;
}
