# home lab
# local connection

## charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.28.5+k3s1

## jack: worker
k3sup join --ip 192.168.0.11 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

## kate: worker
k3sup join --ip 192.168.0.12 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

# ock8s
# connection over tailscale

## oca4: master
k3sup install --host oca4 --k3s-extra-args '--disable=servicelb,traefik' --user ubuntu --k3s-version v1.28.5+k3s1

## oca5: worker
k3sup join --host oca5 --server-host oca4 --user ubuntu --k3s-version v1.28.5+k3s1

## oca6: worker
k3sup join --host oca4 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

## oca7: worker

# deleting nodes

kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>