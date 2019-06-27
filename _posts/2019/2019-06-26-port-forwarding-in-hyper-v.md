---
layout: default
title: Port forwarding in Hyper-V
tags: hyperv nat port forward ssh udp alpine
comments: true
---
# Port forwarding in Hyper-V

This post shows how to use port forwarding in Hyper-V (Windows Pro or Enterprise), to forward ssh requests to an Alpine Linux VM, and to prevent UDP source port translation in datagrams sent out from the VM.

Enable Hyper-V on Windows.

[Configure a new virtual NAT switch](https://www.petri.com/create-nat-rules-hyper-v-nat-virtual-switch) using PowerShell (elevated privilege required)

```powershell
New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"
New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.10.0/24
```

Create a new 64-bit Linux VM and configure it to use the above network switch. [Install](https://www.alpinelinux.org/downloads/) Alpine in the VM.

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

Now, you should be able to ssh into the VM from the host

```bash
ssh root@localhost
```

Install netcat in the VM and try sending out UDP packets to the host at port `8001`

```bash
apk update
apk add netcat-openbsd
nc -u -p 8000 172.20.36.98 8001
```

Use `tcpdump` in VM to see UDP packets

```bash
apk add tcpdump
tcpdump -vv -x -X -i eth0 "port 8000"
```

Use Wireshark on host to see UDP packets. You'll notice that source port `8000` is translated to a random port number by the virtual NAT switch.

Configure port forwarding, using PowerShell, so that UDP port 8000 on host is forwarded to the same port on the VM

```powershell
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 8000 -Protocol UDP -InternalIPAddress "192.168.10.2" -InternalPort 8000 -NatName NATNetwork
```

Try sending out UDP packets with netcat

```bash
nc -u -p 8000 172.20.36.98 8001
```

This time, Wireshark should show you that the source port has not been translated.

[Install Docker](https://wiki.alpinelinux.org/wiki/Docker) in VM, and create a new container

```bash
docker run -it -p 8000:8000/udp alpine sh
```

Send out UDP packets from within the container

```bash
apk update
apk add netcat-openbsd
nc -u -p 8000 172.20.36.98 8001
```

Again, Wireshark should show you that the source port has not been translated.
