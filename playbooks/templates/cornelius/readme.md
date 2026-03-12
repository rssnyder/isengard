# docker compose

systems for running a media server

## setup 

i keep secrets and local path references in an `.env` file next to the compose yaml

the following values are used

```
# where config data is stored
APPDATA=/home/riley/appdata
# temp data storage
SCRATCH_STORAGE=/scratch
# media storage
MEDIA=/mass/media
# less important media storage
RED_MEDIA=/red/media
# generic mass storage disk
MASS=/mass

# private internet access credentials
VPN_USER=''
VPN_PASS=''

# minio root credentials
MINIO_USER=''
MINIO_PASSWORD=''

# immich settings
IMMICH_VERSION=v2.2.1 # release
IMMICH_DB_PASSWORD=postgres
IMMICH_DB_USERNAME=postgres
IMMICH_DB_DATABASE_NAME=immich

# generic admin password
ADMIN_PASSWORD=''
```

I store tv on a specific array so thats what `RED_MEDIA` is, you can probably replace instances where it is used for just `MEDIA`

## services

### media server

- gluetun: sets up vpc connection; all sensitive services run through this container via `network_mode: "service:gluetun"`
- qbt: for media torrent downloads
- nzbget: for usenet downloads
- sonarr: tv downloads
- radarr: movie downloads
- prowlarr: centrally manage indexers for sonarr/radarr
- overseerr: user requests

### other

- deluge: for personal torrent downloads (no vpn)
- minio: mass object storage
- node-exporter-textfiles: add smart data to node exporter
- files: http file server
- immich-server: self hosted photo backup
- immich-machine-learning: support ^
- immich-redis: support ^
- immich-database: support ^
- audiobookshelf: audiobook server for android users
- copyparty: alternative file server
