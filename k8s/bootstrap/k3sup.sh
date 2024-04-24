# charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.28.5+k3s1

# jack: worker
k3sup join --ip 192.168.0.11 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1

# kate: worker
k3sup join --ip 192.168.0.12 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1


kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>