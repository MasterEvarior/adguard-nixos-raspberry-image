{
  adguard = {
    filters = [
      {
        name = "URL House";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
      }
      {
        name = "AdAway Default Blocklist";
        url = "https://adaway.org/hosts.txt";
      }
      {
        name = "Abuse.ch";
        url = "https://urlhaus.abuse.ch/downloads/hostfile/";
      }
      {
        name = "The Big List of Hacked Malware Web Sites";
        url = "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hosts";
      }
      {
        name = "AdGuard MobileFilter";
        url = "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/specific_app.txt";
      }
    ];
    blockedServices = [
      "facebook"
      "betano"
      "betfair"
      "blaze"
      "betway"
      "shein"
    ];
  };

  machine = {
    hostname = "adguard";
  };

  user = {
    username = "stan";
    noPassword = true;
    initialPassword = "test123";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgX2NzC50UtAF/0/AGWSY2x3EvunwPQ5kHiVkQzyMVN noname";
  };
}
