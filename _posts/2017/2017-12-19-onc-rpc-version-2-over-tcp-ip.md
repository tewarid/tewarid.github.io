---
layout: default
title: ONC RPC version 2 over TCP/IP
tags: onc rpc tcp network
---

This post discusses message structure of the Open Network Computing (ONC) remote procedure call (RPC) version 2\. The protocol is specified in IETF [RFC 5531](https://tools.ietf.org/html/rfc5531). [RFC 4506](https://tools.ietf.org/html/rfc4506) specifies the C-like data representation syntax used in RFC 5531\. [RFC 1833](https://tools.ietf.org/html/rfc1833) specifies an RPC service (portmapper) used to discover RPC services provided by a host.

![ONC RPC in Wireshark](/assets/img/onc-rpc-dissector.png) Wireshark RPC dissector

The ONC RPC message structure is defined in the specification as follows

```c
struct rpc_msg {
    unsigned int xid;               /* transaction id */
    union switch (msg_type mtype) { /* message type */
    case CALL:
        call_body cbody;
    case REPLY:
        reply_body rbody;
  } body;
};
```

An unsigned int, according to the XDR specification, is a 4-byte unsigned integer value in big-endian byte order. Transaction id is therefore a 4-byte value. Message type is also an unsigned int value. A value of 0 indicates a call, 1 indicates a reply.

Message fragmentation is used over a stream oriented protocol such as TCP. Transaction id is therefore preceded by a unsigned int value that indicates the size of the fragment in bytes. The most significant bit (MSB) of the unsigned int is a boolean value that, when set, indicates the last fragment of a sequence of fragments.

The call body in turn is defined as follows

```c
struct call_body {
    unsigned int rpcvers;  /* must be equal to two (2) */
    unsigned int prog;     /* program identifier */
    unsigned int vers;     /* program version number */
    unsigned int proc;     /* remote procedure number */
    opaque_auth cred;      /* authentication credentials */
    opaque_auth verf;      /* authentication verifier */
    /* procedure-specific parameters start here */
};

enum auth_flavor {
    AUTH_NONE = 0
    /* and more */
};

struct opaque_auth {
    auth_flavor flavor;    /* authentication flavor */
    opaque body<400>;
};
```

If authentication flavor in use is AUTH_NONE, authentication credentials is an unsigned int value of 0, followed by another unsigned int value indicating an authentication credential body size of 0\. Authentication verifier is encoded in the same manner.

A reply is defined as follows

```c
union reply_body switch (reply_stat stat) { /* Reply status */
case MSG_ACCEPTED:
    accepted_reply areply;
case MSG_DENIED:
    rejected_reply rreply;
} reply;

struct accepted_reply {
    opaque_auth verf;
    union switch (accept_stat stat) { /* accepted status */
    case SUCCESS:
        opaque results[0];
        /*
        * procedure-specific results start here
        */
    case PROG_MISMATCH:
        struct {
            unsigned int low;
            unsigned int high;
        } mismatch_info;
    default:
        /*
        * Void.  Cases include PROG_UNAVAIL, PROC_UNAVAIL,
        * GARBAGE_ARGS, and SYSTEM_ERR.
        */
        void;
    } reply_data;
};

union rejected_reply switch (reject_stat stat) {
case RPC_MISMATCH:
    struct {
        unsigned int low;
        unsigned int high;
    } mismatch_info;
case AUTH_ERROR:
    auth_stat stat;
};
```

Reply status is an unsigned int value, followed by the authentication verifier encoded as explained earlier. A reply status value of 0 indicates an accepted message, which is followed by an unsigned int indicating accepted status (0 is success). A reply status of 1 indicates a rejected message, which is followed by an unsigned int indicating rejection status.

Blocks - string or opaque data, are padded with 0 to 3 residual bytes so that their length is a multiple of 4.