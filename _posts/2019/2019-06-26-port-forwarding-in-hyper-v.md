---
layout: default
title: Port forwarding in Hyper-V
tags: hyperv nat port forward ssh alpine
comments: true
---
# Port forwarding in Hyper-V

This post shows how to use port forwarding in Hyper-V (Windows Pro or Enterprise), to forward ssh requests to an Alpine Linux VM.

Enable Hyper-V using the _Turn Windows features on or off_ Control Panel applet.

[Configure a new virtual NAT switch](https://www.petri.com/create-nat-rules-hyper-v-nat-virtual-switch) using PowerShell (elevated privilege required)

```powershell
New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"
New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.10.0/24
```

Create a new 64-bit Linux VM and configure it to use the above network switch. [Download](https://www.alpinelinux.org/downloads/) and [setup](https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts) Alpine in the VM.

To be able to ssh into the VM from the host, you need to forward TCP port 22 to the same port number on the VM.

Using PowerShell

```powershell
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 22 -Protocol TCP -InternalIPAddress "192.168.10.2" -InternalPort 22 -NatName NATNetwork
```

Finally, edit `/etc/ssh/sshd_config` in Alpine to enable login for root user

```conf
PermitRootLogin yes
```

Restart sshd service

```bash
service sshd restart
```

Now, you should be able to ssh into the VM from localhost or any host on the same network

```bash
ssh root@localhost
```
