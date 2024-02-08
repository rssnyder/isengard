# charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.28.5+k3s1

# ripper: worker
k3sup join --ip 192.168.0.226 --server-ip 192.168.0.10 --user riley

# t480: worker
k3sup join --ip 192.168.0.4 --server-ip 192.168.0.10 --user riley --k3s-version v1.28.5+k3s1


kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>