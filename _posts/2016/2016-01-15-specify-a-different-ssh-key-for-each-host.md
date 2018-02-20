---
layout: default
title: Specify a different ssh key for each host
tags: ssh key config
---

The `~/.ssh/config` file can be edited to specify a different key/identity for each host. This is useful when you have different ssh keys setup on different git servers.

```text
Host mycompany
    HostName mycompany.com
    User fooey
Host github.com
    IdentityFile ~/.ssh/github.key
```

If you specify a HostName that is different from Host, the `.git/config` file should use the name specified in Host. That should also be the host name used in git commands such as clone and remote.

See [Simplify Your Life With an SSH Config File](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/) for more.
