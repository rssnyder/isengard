resource "digitalocean_droplet" "do0" {
  name = "do0"

  image      = "ubuntu-20-04-x64"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    "98:9f:0d:4f:10:dc:61:a5:c5:14:f1:5a:88:cf:c1:76",
    "98:36:f6:72:ca:4e:5a:68:e6:3e:a1:aa:9f:76:61:73"
  ]
}

resource "digitalocean_droplet" "do1" {
  name = "do1"

  image      = "ubuntu-20-04-x64"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    "98:9f:0d:4f:10:dc:61:a5:c5:14:f1:5a:88:cf:c1:76",
    "98:36:f6:72:ca:4e:5a:68:e6:3e:a1:aa:9f:76:61:73"
  ]
}

resource "digitalocean_droplet" "do2" {
  name = "do2"

  image      = "ubuntu-20-04-x64"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    "98:9f:0d:4f:10:dc:61:a5:c5:14:f1:5a:88:cf:c1:76",
    "98:36:f6:72:ca:4e:5a:68:e6:3e:a1:aa:9f:76:61:73"
  ]
}

resource "digitalocean_droplet" "do3" {
  name = "do3"

  image      = "ubuntu-20-04-x64"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    "98:9f:0d:4f:10:dc:61:a5:c5:14:f1:5a:88:cf:c1:76",
    "98:36:f6:72:ca:4e:5a:68:e6:3e:a1:aa:9f:76:61:73"
  ]
}

resource "digitalocean_droplet" "do4" {
  name = "do4"

  image      = "ubuntu-20-04-x64"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    "98:9f:0d:4f:10:dc:61:a5:c5:14:f1:5a:88:cf:c1:76",
    "98:36:f6:72:ca:4e:5a:68:e6:3e:a1:aa:9f:76:61:73"
  ]
}