# lab

## charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.28.5+k3s1

## jack: worker
k3sup join --ip 192.168.0.11 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

## kate: worker
## https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
## restart k3s-agent
## kubectl label nodes kate disktype=ssd
k3sup join --ip 192.168.0.12 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

# oc

## raw
### oca0 
k3sup install --ip 10.0.0.117 --external-ip 10.0.0.117 --k3s-extra-args '--disable=traefik' --k3s-version v1.30.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.31 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.82 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.242 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
### oca4
k3sup install --ip 10.0.0.48 --k3s-extra-args '--disable=traefik' --k3s-version v1.30.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.53 --server-ip 10.0.0.48 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.63 --server-ip 10.0.0.48 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.136 --server-ip 10.0.0.48 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
### oca6
k3sup install --ip 10.0.0.73 --k3s-extra-args '--disable=traefik' --k3s-version v1.30.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.168 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.144 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.7 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu



## custom tailscale

## oca0: master
export TS_IP="100.104.6.19"
k3sup install \
    --ip "$TS_IP" \
    --user "ubuntu" \
    --k3s-version  v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --advertise-address $TS_IP \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --flannel-external-ip \
        --node-label public=true \
        --node-label cloud=oracle"

## oca1: worker
export TS_IP="100.73.195.69"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca2: worker
export TS_IP="100.88.220.53"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca3: worker
export TS_IP="100.84.7.44"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca4: worker
export TS_IP="100.123.169.108"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca5: worker
export TS_IP="100.100.52.93"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca6: worker
export TS_IP="100.113.95.28"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca7: worker
export TS_IP="100.114.218.73"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca8: worker
export TS_IP="100.105.104.73"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca9: worker
export TS_IP="100.87.134.119"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca10: worker
export TS_IP="100.101.18.42"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"

## oca11: worker
export TS_IP="100.118.223.101"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle"















          ansible_host: 129.146.149.166
        oca1:
          ansible_host: 129.153.217.210
        oca2:
          ansible_host: 158.101.27.222
        oca3:
          ansible_host: 144.24.58.138
        oca4:
          ansible_host: 129.153.95.143
        oca5:
          ansible_host: 129.146.157.81
        oca6:
          ansible_host: 144.24.63.75
        oca7:
          ansible_host: 129.146.43.216
        oca8:
          ansible_host: 129.153.144.225
        oca9:
          ansible_host: 129.158.255.22
        oca10:
          ansible_host: 129.158.237.210
        oca11:
          ansible_host: 129.158.243.254


# connection over tailscale

## oca0: master
export TS_IP="100.104.6.19"
k3sup install \
    --ip "$TS_IP" \
    --user "ubuntu" \
    --k3s-version  v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --advertise-address $TS_IP \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --flannel-external-ip \
        --node-label public=true \
        --node-label cloud=oracle"

## oca1: worker
export TS_IP="100.107.23.12"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca2: worker
export TS_IP="100.126.34.40"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca3: worker
export TS_IP="100.74.114.24"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca4: worker
export TS_IP="100.65.220.30"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca5: worker
export TS_IP="100.90.33.35"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca6: worker
export TS_IP="100.114.61.47"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca7: worker
export TS_IP="100.67.168.17"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca8: worker
export TS_IP="100.83.34.85"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca9: worker
export TS_IP="100.91.234.80"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca10: worker
export TS_IP="100.73.94.44"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

## oca11: worker
export TS_IP="100.71.84.23"
k3sup join \
    --ip "$TS_IP" \
    --server-ip "100.104.6.19" \
    --user "ubuntu" \
    --k3s-version v1.30.1+k3s1 \
    --k3s-extra-args "--flannel-iface tailscale0 \
        --node-ip $TS_IP \
        --node-external-ip $TS_IP \
        --node-label public=false \
        --node-label cloud=oracle \
        --vpn-auth="name=tailscale,joinKey=

# deleting nodes

kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>