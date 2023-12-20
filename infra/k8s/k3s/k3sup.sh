# charlie: master
k3sup install --ip 192.168.0.10 --k3s-extra-args '--disable=servicelb,traefik --kubelet-arg="config=/data/rancher/kubelet.config"' --user riley

# ripper: worker
k3sup join --ip 192.168.0.226 --server-ip 192.168.0.10 --user riley

# t480: worker
k3sup join --ip 192.168.0.4 --server-ip 192.168.0.10 --user riley
