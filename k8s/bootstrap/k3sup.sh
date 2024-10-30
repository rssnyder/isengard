# lab

## charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.31.0+k3s1

## jack: worker
k3sup join --ip 192.168.0.11 --server-ip 192.168.0.10 --user riley --k3s-version v1.31.0+k3s1

## kate: worker
## https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
## restart k3s-agent
## kubectl label nodes kate disktype=ssd
k3sup join --ip 192.168.0.12 --server-ip 192.168.0.10 --user riley --k3s-version v1.31.0+k3s1

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

# urbandale

## zaius: single-node
k3sup install --ip 192.168.0.132 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.31.0+k3s1

# deleting nodes

kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>