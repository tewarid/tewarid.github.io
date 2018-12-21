---
layout: default
title: Secure file transmission using asymmetric cryptography
tags: crypto cryptography web data network asymmetric public key
comments: true
---
# Secure file transmission using asymmetric cryptography

The secure file transmission mechanism, depicted in the diagram below, has the following properties

* Authentication

    Alice has a unique securely-held private key

* Non-repudiation

    Alice has a unique securely-held private key

* Data Integrity

    Program signs data using Alice's private key

* Data Confidentiality

    Program encrypts data using Alice's private key

<div class="mermaid">
graph LR
    Program-->data["Encrypted Data"]
    data-->Server
    subgraph Alice
    priva["Alice's Private Key"]-->Program
    pubb["Server's Public Key"]-->Program
    file1["File"]-->Program
    end
    subgraph Server
    privb["Server's Private Key"]-->Server
    puba["Alice's Public Key"]-->Server
    Server-->file2["File"]
    end
</div>

Here's how the mechanism works

1. Program calculates a secure hash of file data
2. Program encrypts file data using a randomly generated secret key
3. Program encrypts hash and secret key using Alice's private key, and Server’s public key
4. Program transmits all encrypted data to Server
5. Server decrypts hash and secret key using its private key and Alice's public key
6. Server decrypts file data using secret key
7. Server calculates hash of file data and compares it with hash sent by Program
