(mostly) everything-as-code (some code, somewhere)

i enjoy breaking and rebuilding things so everything is in constant motion

# playbooks

Here are all my ansible playbooks for various tasks performed across many machines. These range from taking backups of my important data to setting up a machine with a baseline set of tools.

Some of the primary playbooks are `nix` which copies across nix-configs and rebuilds the OS, `caddy` which reloads my various reverse-proxies, and `backup` which pull important data from the cloud to backup locally, important local data offsite, and soon to push another copy to another cloud to complete my 3-2-1 backup.

# infra

As most of my infrastructure is bare-metal I don't provision much through [OpenTofu](https://opentofu.org/), mainly my DNS records.

I manage public DNS through [DigitalOcean](https://www.digitalocean.com/) (a free service with amazing TF support) and locally through [PiHole](https://pi-hole.net/). I have a [local module](https://github.com/rssnyder/isengard/tree/master/infra/external-internal-dns) written to make public DNS recods resolve to local IPs when using my external services from within my lab.

# k8s

All of my various Kubernetes manifests live here. I run several k3s clusters, but am working in my local "micro" cluster 99% of the time. I also have a single node cluster offsite and a four node cluster in [Oracle Cloud](https://www.oracle.com/cloud/free-1/) running the few remaining Discord Bots I am paid to host. Check out their free tier, seriously.

The following describe the various service I use to build my local platform.

## storage

### [longhorn](https://longhorn.io/)

Ranchers storage offering. Stupid simple to set up (but does require some hacks to get working on nixos).

Has proven useful many times. I have been able to yank nodes offline and workloads rebalance and volumes recreate on avalible nodes no problems.

Nightly backups of all volumes are done to my self-hosted S3 provider (Minio). This allows backup/restore from any cluster local or remote. I have tested DR from local cluster to a cloud cluster and it works perfectly.

I know something like ceph would be better for performance, but at the moment I don't need iops and don't want the pain of managing it. I have looked at rook-ceph a few time but never wanted to commit to deploying it. That also requires second disks on nodes and right now a lot of my nodes only have one drive slot.

I also use the OS disk as the storage disk which is very bad. I am planning on changing this soon.

## network

### [metallb](https://metallb.io/)

To implement a local "load balancer" I use MetalLB that has been given a /24 local subnet. This lets me expose local-only services as well as services I want to eventually make public via ingress.

### [nginx](https://github.com/kubernetes/ingress-nginx)

For public services I use nginx ingress. I do not do HTTPS termination in the cluster so theres no special config here. My public caddy server has a wildcard record for `*.k8s.rileysnyder.dev` so I can expose services just by creating an ingress resource.

When I have full production apps, I create a new DNS record via DO+TF, update my caddyfile, and then everything routes to the ingress controller just fine.

### [tailscale](https://tailscale.com/kb/1236/kubernetes-operator)

For "internal" services that I was reachable while I am out and about, I use the tailscale operator to connect services to my tailnet.

This is done simply by adding a few annotations:
```
tailscale.com/expose: "true"
tailscale.com/hostname: "example"
```

## database

### [cloud native postgres](https://cloudnative-pg.io/)

If an application needs a database, I run the cnpg operator to get per-application clusters deployed. CNPG sold me when I saw how easy it was to pass the credentials to an app with automatically created secrets.

For backups, CNPG supports backup and restore from S3 using Barman Object Store. For most cluster I schedule nightly backups, and again have tested recovery both locally and to the cloud.

## secrets

### [sealed secrets](https://github.com/bitnami-labs/sealed-secrets)

I used to deploy my secerts by putting the string in ansible-vault, and rendering the secret manifests on the server's manifest directory. This created a problem where secrets were deployed seperatly from the application and I always hated this. My reasoning being I wanted everything in git.

I recently discovered Sealed Secrets which let me put the full secret resource right in the application manifest (no jinja2) and deploy it along with the app. I still need to figure out DR for this as redeploying to a new cluster (with a new sealing key) would result in needed to reseal the secrets (change the manifest). I just need to schedule exporing the sealing key, backing it up, and add restoring it to my cluster baseline.

I really need to use an external secret store, but running vault at this point isnt something I am interested in.

## deployments

### [baseline](https://github.com/rssnyder/isengard/tree/master/k8s/baseline)

To provision the cluser baseline, I use ansible to provision the baseline manifests to the k3s server manifests directory.

This way I can do a machine and cluster bootstrap with ansible, and easily template the manifests depending on the host (cluster) we are deploying to.

I have provisioned clusters with an ansible role, k3sup, and now by hand with nix-configs. K3sup is amazing and I highly recommend it if you want to get start quickly (I am a huge fan of Alex).

### applications

For everything else in the cluster, unfortunetly I deploy everything with `kubectl apply -f` (or more accuratly the ohmyzsh alias `kaf`).

I work for a company that makes a CI/CD tool, so I do it all day long, and just want a break when I swap laptops after 5pm.

To see everything work together, I keep a running example of using all of the above services [here](https://github.com/rssnyder/isengard/blob/master/k8s/example/example.yaml).

# servers

## hurley (raspberry pi 4 | raspian)

The entrypoint of my network is my pi. This runs my main Caddy reverse proxy, and my home router forwards 80/443 here to be redirected to various applications. Some local, external but reachable through tailscale.

This machine also runs various services using docker-compose, like Grafana, Minio (S3), Omada Controller, and Postgres.

I used to do all my development on this machine using VSCode web, but have since migrated to t480-0 below.

Currently mounted in my custom 3d printed rack.

## t480-0 (lenovo thinkpad t480 | nixos)

This is my new main development machine. I do all development here via VSCode Server.

I also run Prometheus (used to run on my pi but was causing performance issues), serveral Minecraft servers, GitHub runners (hopefully no one from work sees this), and a local container registry.

Mounted in my freezing garage and needs to be renamed.

![20241223_123418](https://github.com/user-attachments/assets/285af0c1-acb0-480f-a3b4-e40e56286d07)

## plex (lenovo thinkpad t480 | nixos )

Hosting my Plex and *arr stack through docker-compose is another t480 (sourced from a clean dumpster). Accesses my ZFS pool for media storage via NFS.

Also mounted in my garage.

## zira (custom | ubuntu server)

Made from various dumpster Dell desktops and Ebay parts, this is my storage server.

It runs my file server and bittorrent clients using docker-compose.

- zfs pools
    - bucket - media + long term storage
        - x2 18tb mirror
        - x2 24tb mirror
        - 42tb usable
    - scratch - download cache, misc. files
        - x2 2tb zfs raid zero
        - 4tb usable

In my storage/laundry room, below the water main, proving ambiant heat for my basil plants.

![20250121_103205](https://github.com/user-attachments/assets/a190190f-c91d-4824-9db7-43c60adfb623)

The side panel was off to do some data migration to an extra drive.

## ben (gmtec g3 | nixos)

Traded an old dumpster laptop for this off marketplace. It is the server (master) node in my local k3s cluster.

Also mounted in my rack, the namesake of my "micro" cluster.

## jack (dell precision 7520 | ubuntu server)

The agent (worker) node of my local "micro" cluster. Has a [coral tpu](https://coral.ai/products/) and zigbee reciver for running frigate and home assistant for security and automation.

Also provides heat to my plants.

## claire (lenovo thinkpad t480 | nixos)

Another dumpster laptop, was an agent node in the previous iteration of my local cluster, but these days idle and looking for work.

Another garage machine.

## zaius (dell precision t1700 | ubuntu server)

Wouldn't you guess, another dumpster machine. Has a single disk 10TB ZFS pool for backing up critical data, and runs a single node k3s cluster "urban" which dosn't have anything running on it at the moment.

Currently in my parents basement.

# hardware

My main network is a TP-Link router and switch which are mounted in a custom 3d printed rack that hangs from the underside of my sit/stand desk. My switch has four POE ports which are routed to:
- TP-Link access point in my living room
- Amcrest camera in my lab (what I call my office)
- Amcrest camera mounted on my roof covering the front yard
- POE pass through switch in my garage

The custom rack also has mounts for the following devices:
- Aplifier: for my desktop speakers
- Hurley (listed above)
- Ben (listed above)
- HDHomerun: for recording local over-the-air tv via Plex

![20250122_191507](https://github.com/user-attachments/assets/680871de-9db4-4b28-9914-b40eee83ac17)

