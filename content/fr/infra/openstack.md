Create instance openstack

## Ajouter une clé SSH

Inside openstack client
keypair create --public-key gfaivre@elao.com.pub gfaivre

From shell
openstack keypair create --public-key gfaivre@elao.com.pub gfaivre

## Résultat

```
root@7f987fba241f:/srv# openstack keypair create --public-key gfaivre@elao.com.pub gfaivre
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 1e:25:14:0c:g4:2e:nc:25:8b:d4:e6:35:16:1r:88:c2 |
| name        | gfaivre                                         |
| user_id     | 75de139e2b4b48a4b807208664c989bb                |
+-------------+-------------------------------------------------+
```

## Lister les clés SSH

```
(openstack) keypair list
+---------+-------------------------------------------------+
| Name    | Fingerprint                                     |
+---------+-------------------------------------------------+
| gfaivre | 1e:25:14:0c:g4:2e:nc:25:8b:d4:e6:35:16:1r:88:c2 |
+---------+-------------------------------------------------+
```

## Supprimer une clé SSH

Keypair delete gfaivre

## Liste des instances
Consulter les différentes versions d'instances disponibles

```
flavor list
```

```
+--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
| ID                                   | Name                |    RAM | Disk | Ephemeral | VCPUs | Is Public |
+--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
| 04791e86-8a7d-4431-b316-98485f2a7b97 | win-eg-7-ssd-flex   |   7000 |   50 |         0 |     2 | True      |
| 04e3cc6b-9396-4da2-a4d2-fe47a8cf1d68 | hg-120-flex         | 120000 |   50 |         0 |    32 | True      |
| 068f098e-e1b1-4f31-8441-ad3c0eeacc72 | hg-7-ssd            |   7000 |  100 |         0 |     2 | True      |
| 0905853d-3b66-4c24-8081-b710fa649015 | win-eg-30           |  30000 |  800 |         0 |     8 | True      |
| 0c36bb1d-bd1e-4294-ac75-60fd727054c8 | win-hg-15           |  15000 |  400 |         0 |     4 | True      |
...
| fe42ca0a-3840-42b2-847d-3143cc2adc52 | eg-120              | 120000 | 1600 |         0 |    32 | True      |
| ff8c4a3e-6cd8-4db4-9500-8a0f1bbb8f19 | sp-30-flex          |  30000 |   50 |         0 |     2 | True      |
+--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
```

## Liste des images (OS)

`image list`

```
(openstack) image list
+--------------------------------------+-------------------------------+--------+
| ID                                   | Name                          | Status |
+--------------------------------------+-------------------------------+--------+
| d0e79eb7-5dbe-4ff2-84f9-d5ce26ef074e | Debian 8                      | active |
| eebec8ed-1444-4808-b1d8-f85a86d26fb7 | Windows 2016 Standard Server  | active |
| 5a0dd931-1f0a-4382-add7-cda081bb12e1 | Fedora 25                     | active |
| 84b45fd4-5276-4ce7-905f-a6e8d069f00b | Windows-Server-2012-r2        | active |
| ef446cba-1cba-4c30-913e-c5d6605a94f9 | rescue-ovh                    | active |
| ff09fa06-b8d2-4b2b-a2af-fbfde55b7464 | Windows 2016 Standard Desktop | active |
| 4d1a7923-8720-4569-8b5d-11ec5c9ab255 | Debian 7                      | active |
| 884794e0-a47b-489e-a911-e71d3d546453 | CoreOS Stable                 | active |
| 8a3f48c8-c3fb-439f-be00-3bf9f26f6fc5 | Centos 7                      | active |
| d74969a8-b3c5-459d-a8f7-0dbd21f76f61 | FreeBSD 11.0 ZFS              | active |
| a4fd9ec9-1692-4ea0-bd0b-7ec8072048a8 | Ubuntu 16.10                  | active |
| b0e68d0f-e963-44fb-b347-64d0214c3fa1 | Ubuntu 14.04                  | active |
| 03be11dd-a44f-434c-8cb5-5328788baba4 | FreeBSD 11.0 UFS              | active |
| 004c38a1-67e8-46d8-8225-4bb789a80ae3 | Fedora 24                     | active |
| 6340347a-7e36-43e0-996c-07fce105e70c | Centos 6                      | active |
| d79802bf-0b36-47a4-acb6-76a293b0c037 | Ubuntu 16.04                  | active |
| 5b03f136-4fbc-472d-931a-1be08d9c506c | Ubuntu 15.10                  | active |
| 3031ed24-8337-4b09-94b5-e51c54bec6c8 | Ubuntu 12.04                  | active |
| a5006914-ef04-41f3-8b90-6b99d0260a99 | FreeBSD 10.3 UFS              | active |
| 5a13b9a6-02f6-4f9f-bbb5-b131852888e8 | FreeBSD 10.3 ZFS              | active |
| 57b9722a-e6e8-4a55-8146-3e36a477eb78 | Fedora 20                     | active |
| 7250cc02-ccc1-4a46-8361-a3d6d9113177 | Fedora 19                     | active |
+--------------------------------------+-------------------------------+--------+
```

## Network

```
(openstack) network list
+--------------------------------------+--------------+----------------------------------------------------------------------------+
| ID                                   | Name         | Subnets                                                                    |
+--------------------------------------+--------------+----------------------------------------------------------------------------+
| 8d3e91fd-c533-418f-8678-4252de201489 | Ext-Net      | 76ae273a-736e-4a65-aacc-e56f80d2b9db, a92ff450-0b85-4f46-b98a-33d3cfe0dbe3 |
| dfbdbfc8-7aec-4668-bc5d-6374c0229032 | VLAN_Sandbox | a60a0e4a-916b-480c-bcd0-55b38a3eaa71                                       |
+--------------------------------------+--------------+----------------------------------------------------------------------------+
```

## Création d'une instance


nova boot --flavor vps-ssd-1 --image "Debian 8" --nic net-id=8d3e91fd-c533-418f-8678-4252de201489 --key-name gfaivre Instance_API_Test
server create --availability-zone BRX1 --flavor vps-ssd-1 --image "Debian 8" --nic net-id=8d3e91fd-c533-418f-8678-4252de201489 --key-name gfaivre Instance_API_Test

```
(openstack) server show Instance_API_Test
+--------------------------------------+----------------------------------------------------------+
| Field                                | Value                                                    |
+--------------------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                   |
| OS-EXT-AZ:availability_zone          | nova                                                     |
| OS-EXT-STS:power_state               | Running                                                  |
| OS-EXT-STS:task_state                | None                                                     |
| OS-EXT-STS:vm_state                  | active                                                   |
| OS-SRV-USG:launched_at               | 2016-12-28T12:11:00.000000                               |
| OS-SRV-USG:terminated_at             | None                                                     |
| accessIPv4                           |                                                          |
| accessIPv6                           |                                                          |
| addresses                            | Ext-Net=149.202.180.246                                  |
| config_drive                         |                                                          |
| created                              | 2016-12-28T12:08:30Z                                     |
| flavor                               | vps-ssd-1 (98c1e679-5f2c-4069-b4da-4a4f7179b758)         |
| hostId                               | 8dad3a8de8f5ce4c55e4fc343a1458e638cb0acc9091fc61f99283d8 |
| id                                   | c1b48c08-9eed-474c-9ba5-c375a7145070                     |
| image                                | Debian 8 (d0e79eb7-5dbe-4ff2-84f9-d5ce26ef074e)          |
| key_name                             | gfaivre                                                  |
| name                                 | Instance_API_Test                                        |
| os-extended-volumes:volumes_attached | []                                                       |
| progress                             | 0                                                        |
| project_id                           | f030b689207b4a7aba6c26f123011e70                         |
| properties                           |                                                          |
| security_groups                      | [{u'name': u'default'}]                                  |
| status                               | ACTIVE                                                   |
| updated                              | 2016-12-28T12:11:00Z                                     |
| user_id                              | 75de139e2b4b48a4b807208664c989bb                         |
+--------------------------------------+----------------------------------------------------------+
```

## Suppression d'une instance

server delete Instance_API_Test

# Gestion du réseau

Alternative au client openstack:

```
(neutron) net-list
+--------------------------------------+--------------+-------------------------------------------------------+
| id                                   | name         | subnets                                               |
+--------------------------------------+--------------+-------------------------------------------------------+
| 8d3e91fd-c533-418f-8678-4252de201489 | Ext-Net      | 76ae273a-736e-4a65-aacc-e56f80d2b9db XXX.XX.XX.0/21   |
|                                      |              | a92ff450-0b85-4f46-b98a-33d3cfe0dbe3 XXX.XXX.XXX.0/19 |
| dfbdbfc8-7aec-4668-bc5d-6374c0229032 | VLAN_Sandbox | a60a0e4a-916b-480c-bcd0-55b38a3eaa71 192.168.2.0/24   |
+--------------------------------------+--------------+-------------------------------------------------------+
```

## Attacher une nouvelle interface

### Liste des instances

```
root@47a162c5352d:/srv# nova list
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
| ID                                   | Name              | Status | Task State | Power State | Networks                                           |
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
| 5ac801ce-7a2e-463f-bae0-7a9f2a8e6277 | Instance_API_Test | ACTIVE | -          | Running     | Ext-Net=XXX.XXX.XX.XX                               |
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
```

### Liste des interfaces

```
nova interface-list Instance_API_Test
+------------+--------------------------------------+--------------------------------------+--------------+-------------------+
| Port State | Port ID                              | Net ID                               | IP addresses | MAC Addr          |
+------------+--------------------------------------+--------------------------------------+--------------+-------------------+
| ACTIVE     | 817bbcea-885e-4ae8-b640-d2179fc88710 | 8d3e91fd-c533-418f-8678-4252de201489 | 213.32.73.16 | fa:16:3e:3e:f8:a5 |
+------------+--------------------------------------+--------------------------------------+--------------+-------------------+
```

### Ajout d'une interface avec ip fixe

`nova interface-attach --net-id dfbdbfc8-7aec-4668-bc5d-6374c0229032 --fixed-ip 192.168.2.69 Instance_API_Test`

```
root@47a162c5352d:/srv# nova list
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
| ID                                   | Name              | Status | Task State | Power State | Networks                                           |
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
| 5ac801ce-7a2e-463f-bae0-7a9f2a8e6277 | Instance_API_Test | ACTIVE | -          | Running     | Ext-Net=XXX.XXX.XX.XX; VLAN_Sandbox=192.168.2.69    |
+--------------------------------------+-------------------+--------+------------+-------------+----------------------------------------------------+
```

#Liste des extensions

```
(neutron) ext-list -D
+-----------------------+-----------------------------------------------+
| alias                 | name                                          |
+-----------------------+-----------------------------------------------+
| ext-gw-mode           | Neutron L3 Configurable external gateway mode |
| security-group        | security-group                                |
| ipalias               | Neutron IP alias                              |
| l3_agent_scheduler    | L3 Agent Scheduler                            |
| fwaas                 | Firewall service                              |
| binding               | Port Binding                                  |
| provider              | Provider Network                              |
| agent                 | agent                                         |
| quotas                | Quota management support                      |
| dhcp_agent_scheduler  | DHCP Agent Scheduler                          |
| l3-ha                 | HA Router extension                           |
| multi-provider        | Multi Provider Network                        |
| external-net          | Neutron external network                      |
| router                | Neutron L3 Router                             |
| allowed-address-pairs | Allowed Address Pairs                         |
| extraroute            | Neutron Extra Route                           |
| extra_dhcp_opt        | Neutron Extra DHCP opts                       |
| vrack                 | OVH Vrack in Neutron                          |
| dvr                   | Distributed Virtual Router                    |
+-----------------------+-----------------------------------------------+
```

### Exemple

```
(neutron) ext-show vrack
+-------------+-----------------------------------------------------------------+
| Field       | Value                                                           |
+-------------+-----------------------------------------------------------------+
| alias       | vrack                                                           |
| description | Add OVH Vrack 3.0 in neutron db to create tenant networks in it |
| links       |                                                                 |
| name        | OVH Vrack in Neutron                                            |
| namespace   | http://ovh.net/cloud/openstack/ext/neutron/vrack/api/v1.0       |
| updated     | 2015-11-12T12:00:00-00:00                                       |
+-------------+-----------------------------------------------------------------+
```

## Réseaux

```
(neutron) net-list
+--------------------------------------+--------------+-------------------------------------------------------+
| id                                   | name         | subnets                                               |
+--------------------------------------+--------------+-------------------------------------------------------+
| 8d3e91fd-c533-418f-8678-4252de201489 | Ext-Net      | 76ae273a-736e-4a65-aacc-e56f80d2b9db 213.32.72.0/21   |
|                                      |              | a92ff450-0b85-4f46-b98a-33d3cfe0dbe3 149.202.160.0/19 |
| dfbdbfc8-7aec-4668-bc5d-6374c0229032 | VLAN_Sandbox | a60a0e4a-916b-480c-bcd0-55b38a3eaa71 192.168.2.0/24   |
+--------------------------------------+--------------+-------------------------------------------------------+
```

## Sous réseaux

```
(neutron) subnet-show a60a0e4a-916b-480c-bcd0-55b38a3eaa71
+-------------------+---------------------------------------------------+
| Field             | Value                                             |
+-------------------+---------------------------------------------------+
| allocation_pools  | {"start": "192.168.2.66", "end": "192.168.2.128"} |
| cidr              | 192.168.2.0/24                                    |
| dns_nameservers   |                                                   |
| enable_dhcp       | False                                             |
| gateway_ip        | 192.168.2.1                                       |
| host_routes       |                                                   |
| id                | a60a0e4a-916b-480c-bcd0-55b38a3eaa71              |
| ip_version        | 4                                                 |
| ipv6_address_mode |                                                   |
| ipv6_ra_mode      |                                                   |
| name              |                                                   |
| network_id        | dfbdbfc8-7aec-4668-bc5d-6374c0229032              |
| tenant_id         | f030b689207b4a7aba6c26f123011e70                  |
+-------------------+---------------------------------------------------+
```

## Security group

```
(neutron) security-group-list
+--------------------------------------+---------+----------------------------------------------------------------------+
| id                                   | name    | security_group_rules                                                 |
+--------------------------------------+---------+----------------------------------------------------------------------+
| 704a0364-8280-41d9-b7b9-1c9e37524b48 | default | egress, IPv4                                                         |
|                                      |         | egress, IPv6                                                         |
|                                      |         | ingress, IPv4                                                        |
|                                      |         | ingress, IPv4, remote_group_id: 704a0364-8280-41d9-b7b9-1c9e37524b48 |
|                                      |         | ingress, IPv6, remote_group_id: 704a0364-8280-41d9-b7b9-1c9e37524b48 |
+--------------------------------------+---------+----------------------------------------------------------------------+
```

# Configurer le container avec son IP

```
ip addr list
```

```
ip addr add 192.168.2.69/24 dev eth1
```

`ip link set eth1 up`

# Faire communiquer serveurs dédiés avec intances VPS

## Créer un vlan taggé

S'assurer de la présence sur la/les machines dédiées:

Du paquet vlan
`apt-get install vlan`

De la présence du module kernel `8021q`
`lsmod |grep 8021q`

Si celui est absent le charger:

### Temporairement
sudo modprobe 8021q

### Au boot
sudo echo 8021q >> /etc/modules

## Créer l'interface

### Temporairement

```
sudo vconfig add eth1 2
Added VLAN with VID == 2 to IF -:eth1:-
```

```
sudo ip add 192.168.2.68/24 dev eth1.2
```

### Permanent

Editer le fichier `/etc/network/interface`

```
# add vlan 2 on eth1 - static IP address (vRack)
auto eth1.2
iface eth1.2 inet static
 address 192.168.2.68
 netmask 255.255.255.0
```

https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Configure_802_1Q_VLAN_Tagging_Using_the_Command_Line.html
