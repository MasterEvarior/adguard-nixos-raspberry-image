{ ... }:

let
  deCH = "de_CH.UTF-8";
in
{
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = deCH;
      LC_IDENTIFICATION = deCH;
      LC_MEASUREMENT = deCH;
      LC_MONETARY = deCH;
      LC_NAME = deCH;
      LC_NUMERIC = deCH;
      LC_PAPER = deCH;
      LC_TELEPHONE = deCH;
      LC_TIME = deCH;
    };
  };

  time.timeZone = "Europe/Zurich";

  console.keyMap = "sg";
}
