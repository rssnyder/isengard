# network

### 02/25/2026

after many years with pfsense, tplink, and other random brands i have finally decided to upgrade my network to 2.5G and beyond and give-in to the unifi stack. google fiber recently upgraded my bandwidth to 3G which prompted this change.

### 02/28/2026

my router+switch arrives today (ap, sfp+ cables later) so i need to plan out my new network. right now my local network is 192.168.2.0/24 for physical and virual devices, while services running in k8s are under 192.168.253.0/24.

i would still like to keep the .2. cidr for my main network (2 is my favorite number).

i would like to use .20. for devices which should be segmented from user devices, things like google homes which slurp my data constantly.

| name | cidr             |
|------|------------------|
| lan  | 192.168.2.0/24   |
| dmz  | 192.168.20.0/24  |
| k8s  | 192.168.200.0/24 |

ideally devices land in the dmz, where they can only initate traffic to the internet, while other devices and initate traffic to them, and they live there unless otherwise moved to the main lan