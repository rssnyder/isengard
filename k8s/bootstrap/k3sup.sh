# lab
## pod: 10.42.0.0/16
## svc: 10.42.0.0/16

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
## pod: 10.43.0.0/16
## svc: 10.44.0.0/16

### oca0 
k3sup install --ip 10.0.0.117 --external-ip 10.0.0.117 --k3s-extra-args '--disable=traefik' --k3s-version v1.30.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.31 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.82 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.242 --server-ip 10.0.0.117 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu

# ocdr
## pod: 10.45.0.0/16
## svc: 10.46.0.0/16

### oca4
k3sup install --ip 10.0.0.48 --k3s-extra-args '--cluster-cidr "10.45.0.0/16" --service-cidr "10.46.0.0/16"' --k3s-version v1.31.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.53 --server-host 10.0.0.48 --k3s-version v1.31.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.63 --server-ip 10.0.0.48 --k3s-version v1.31.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.136 --server-ip 10.0.0.48 --k3s-version v1.31.1+k3s1 --user ubuntu --server-user ubuntu

# ocdr
## pod: 10.47.0.0/16
## svc: 10.48.0.0/16

### oca6
k3sup install --ip 10.0.0.73 --k3s-extra-args '--disable=traefik' --k3s-version v1.30.1+k3s1 --user ubuntu
k3sup join --ip 10.0.0.168 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.144 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu
k3sup join --ip 10.0.0.7 --server-ip 10.0.0.73 --k3s-version v1.30.1+k3s1 --user ubuntu --server-user ubuntu

# urbandale

## pod: 10.49.0.0/16
## svc: 10.50.0.0/16

## zaius: single-node
k3sup install --ip 192.168.0.132 --k3s-extra-args '--disable=servicelb,traefik' --user riley --k3s-version v1.31.0+k3s1

# deleting nodes

kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>






helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update
helm install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=aws \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=velero \
    --set configuration.backupStorageLocation.config.region=minio-default \
    --set configuration.backupStorageLocation.config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation.config.s3Url=https://s3.rileysnyder.dev \
    --set configuration.backupStorageLocation.config.publicUrl=https://s3.rileysnyder.dev \
    --set snapshotsEnabled=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set configuration.volumeSnapshotLocation.config.region=minio-default \
    --set "initContainers[0].name=velero-plugin-for-aws" \
    --set "initContainers[0].image=velero/velero-plugin-for-aws:v1.6.0" \
    --set "initContainers[0].volumeMounts[0].mountPath=/target" \
    --set "initContainers[0].volumeMounts[0].name=plugins" \
    --set configuration.features=EnableCSI \
    --set "initContainers[1].name=velero-plugin-for-csi" \
    --set "initContainers[1].image=velero/velero-plugin-for-csi:v0.4.0" \
    --set "initContainers[1].volumeMounts[0].mountPath=/target" \
    --set "initContainers[1].volumeMounts[0].name=plugins" \
    vmware-tanzu/velero