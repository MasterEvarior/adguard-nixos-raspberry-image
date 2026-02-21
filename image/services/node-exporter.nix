{ ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    openFirewall = true;
    enabledCollectors = [
      "diskstats"
      "filesystem"
    ];
    disabledCollectors = [
      "nfs"
      "nfsd"
      "nvme"
      "zfs"
      "infiniband"
      "fibrechannel"
    ];
  };
}
