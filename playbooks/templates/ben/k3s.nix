{ pkgs, lib, config, ... }:
{
  # networking.firewall.allowedTCPPorts = [
  #   6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
  #   # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
  #   # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  # ];
  networking.firewall.enable = false;
  services.k3s = {
    enable      =  true;
    role        = "server"; # "agent";
    #serverAddr = "https://192.168.2.65:6443";
    #token = "";
    extraFlags  = "--cluster-cidr=10.50.0.0/16 --service-cidr=10.51.0.0/16 --disable servicelb,traefik --kube-apiserver-arg='feature-gates=ImageVolume=true'";
  };

  # needed for longhorn, along with kyverno in manifests dir
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:ben";
  };
}
