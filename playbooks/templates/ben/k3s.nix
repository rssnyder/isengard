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
    role = "server";
    # clusterInit =  true;
    extraFlags  = "--cluster-cidr=10.50.0.0/16 --service-cidr=10.51.0.0/16 --disable servicelb,traefik";
};
 }