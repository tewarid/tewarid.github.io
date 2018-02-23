---
layout: default
title: tar with different owner and group
tags: tar owner
---

I needed to tar a folder and set all files and folders to owner/group 0/0\. After a few man page perusals and internet searches, this is what worked

```bash
tar cvjf system.tar.bz2 --numeric-owner --owner=root --group=root  ./system
```

Here's what `tar tvjf system.tar.bz2` lists

```text
drwxr-xr-x 0/0               0 2013-07-30 15:53 ./system/
drwxr-xr-x 0/0               0 2013-07-30 15:57 ./system/app/
-rw-r--r-- 0/0           29081 2013-07-30 15:53 ./system/app/ApplicationsProvider.apk
-rw-r--r-- 0/0          109577 2013-07-30 15:53 ./system/app/BackupRestoreConfirmation.apk
-rw-r--r-- 0/0           31705 2013-07-30 15:53 ./system/app/BasicDreams.apk
-rw-r--r-- 0/0          624562 2013-07-30 15:54 ./system/app/Bluetooth.apk
-rw-r--r-- 0/0         2852568 2013-07-30 15:57 ./system/app/Browser.apk
-rw-r--r-- 0/0          970646 2013-07-30 15:56 ./system/app/Calculator.apk
-rw-r--r-- 0/0         1786627 2013-07-30 15:56 ./system/app/Calendar.apk
-rw-r--r-- 0/0          771929 2013-07-30 15:54 ./system/app/CalendarProvider.apk
-rw-r--r-- 0/0          137476 2013-07-30 15:53 ./system/app/CertInstaller.apk
...
```
