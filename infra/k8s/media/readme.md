# media in k8s

learning k8s by setting up someting I have ran in docker for _10 years_

*tested using k3s, metallb, longhorn, and nginx ingress on ubuntu x86 with caddy as an external reverse proxy*

`internet`>`caddy`>`nginx-ingress`>`service`>`pod`

## what's included

qbittorrent: downloading
sonarr/radarr: finding/watching
prowlarr: sourcing
overseerr: requesting
files: sharing

## setup

you will need to set up radarr and sonarr to have qbittorrent as a download client

- host: `qbittorrnet`
- port: `80` (or based on qbittorrent.service.port in values)
- username: `admin`
- password: `adminadmin`

you will then need to configure prowlarr to manage indexers in sonarr and radarr

- prowlarr server: `http://prowlarr:80`
- sonarr server: `http://sonarr:80`
- radarr server: `http://radarr:80`

prowlarr will also need indexers added, some options

- thepiratebay.org
- eztv1.xyz
- torrentgalaxy.to
- 1337x.to

then indexers will be automatically added to radarr/sonarr

## usage

depending on the service/ingress you can access the services at the lb ip and port 80 or at <service>.<ingress.host>

## values

all setting applied via `values.yaml`

```
pvc:
  useExistingVolume: true
```

The above setting is to force the PVCs to leverage existing volumes. I am doing this so that I can leverage longhorn backups when deleting/deploying this project over and over, to start from a clean slate. 

## caddyfile

using [rssnyder/caddy-digitalocean](https://hub.docker.com/r/rssnyder/caddy-digitalocean) made with [digitalocean caddy plugin](https://caddyserver.com/docs/modules/dns.providers.digitalocean)

```
*.<ingress.host> {
    reverse_proxy <nginx-ingress lb ip>

    tls {
        dns digitalocean <digitalocean token>
    }
}
```

## notes

to make a pv avalible for claim again: `kubectl patch pv <pv name> -p '{"spec":{"claimRef": null}}'`
