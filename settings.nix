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
