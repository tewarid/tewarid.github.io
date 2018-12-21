---
layout: default
title: IPv4 Network Calculator
tags: ipv4 ip subnet calculation
comments: true
---
# IPv4 Network Calculator

There is a plethora of online calculators. I couldn't find one that met my needs so I decided to write something simple in JavaScript based on Node.js. The code should be easy to adapt to run inside the browser.

The calculator below requires you to specify the network address, number of subnets, number of hosts per subnet, and prints the subnet mask, the network address of each subnet, and the address range of the hosts in the subnet.

Thus

```bash
node netcalc --n 10.0.0.0 --ns 12 --hs 1
```

Will result in

```text
Subnet mask: 255.255.255.252
Subnet #1
    Network: 10.0.0.4
    Host range: 10.0.0.5 - 10.0.0.6
Subnet #2
    Network: 10.0.0.8
    Host range: 10.0.0.9 - 10.0.0.10
Subnet #3
    Network: 10.0.0.12
    Host range: 10.0.0.13 - 10.0.0.14
Subnet #4
    Network: 10.0.0.16
    Host range: 10.0.0.17 - 10.0.0.18
Subnet #5
    Network: 10.0.0.20
    Host range: 10.0.0.21 - 10.0.0.22
Subnet #6
    Network: 10.0.0.24
    Host range: 10.0.0.25 - 10.0.0.26
Subnet #7
    Network: 10.0.0.28
    Host range: 10.0.0.29 - 10.0.0.30
Subnet #8
    Network: 10.0.0.32
    Host range: 10.0.0.33 - 10.0.0.34
Subnet #9
    Network: 10.0.0.36
    Host range: 10.0.0.37 - 10.0.0.38
Subnet #10
    Network: 10.0.0.40
    Host range: 10.0.0.41 - 10.0.0.42
Subnet #11
    Network: 10.0.0.44
    Host range: 10.0.0.45 - 10.0.0.46
Subnet #12
    Network: 10.0.0.48
    Host range: 10.0.0.49 - 10.0.0.50
```

You'll need to install Node.js, and the optimist module using npm, to run the script. I have used array and string manipulation functions in place of bitwise operators.

```javascript
var argv = require("optimist").argv;

netcalc(argv.n, argv.ns, argv.hs);

function netcalc(n, ns, hs) {

    if (n == undefined || ns == undefined || hs == undefined) {
        console.log('options: --n <network> --ns <number_of_subnets> --hs <hosts_per_subnet>');
        process.exit(-1);
    }

    var bitsForSubnet = (ns.toString(2)).length;

    var numHosts = hs + 1;
        // The address 0 and all ones are special so need to ensure host
        // address is not one of those by adding one

    var bitsForHost = (numHosts.toString(2)).length;

    // Calculate and print subnet mask

    var netMaskb = Array(32-bitsForHost+1).join('1')
        + Array(bitsForHost+1).join('0');

    console.log('Subnet mask: ' + bstoip(netMaskb));

    // Calculate and print subnet info

    for (var i = 0; i < ns ; i++) {
        console.log("Subnet #" + (i+1));

        var nsb = (i+1).toString(2);

        var networkb = iptobs(n);

        var subnetb = networkb.substring(0, networkb.length - nsb.length - bitsForHost)
            + nsb + Array(bitsForHost+1).join('0');

        console.log('    Network: ' + bstoip(subnetb));

        var minhb = subnetb.substring(0, 32 - bitsForHost)
            + Array(bitsForHost).join('0') + '1';

        var maxhb = subnetb.substring(0, 32 - bitsForHost)
            + Array(bitsForHost).join('1') + '0';

        console.log('    Host range: ' + bstoip(minhb) + ' - ' + bstoip(maxhb));
    }
}

// ipv4 to binary string
function iptobs(ip) {
    var ipsplit = ip.split('.');
    if (ipsplit.length != 4) {
        console.log('Network address should be in the IPv4 address format e.g. 10.0.0.0');
        process.exit(-1);
    }
    var b = parseInt(ipsplit[0]).toString(2);
    var bs = Array(8 - b.length + 1).join('0') + b;
    b = parseInt(ipsplit[1]).toString(2);
    bs = bs + Array(8 - b.length + 1).join('0') + b;
    b = parseInt(ipsplit[2]).toString(2);
    bs = bs + Array(8 - b.length + 1).join('0') + b;
    b = parseInt(ipsplit[3]).toString(2);
    bs = bs + Array(8 - b.length + 1).join('0') + b;
    return bs;
}

// binary string to ipv4 format
function bstoip(bs) {
    return parseInt(bs.substring(0, 8), 2) + '.'
        + parseInt(bs.substring(8, 16), 2) + '.'
        + parseInt(bs.substring(16, 24), 2) + '.'
        + parseInt(bs.substring(24, 32), 2);
}
```

If the provided network address does not allow for the specified number of subnets and hosts per subnets it will be truncated without any warning.
