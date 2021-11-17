---
layout: default
title: File virtualization in Windows
tags: windows file permission system virtual store wireshark lua
comments: true
---
# File virtualization in Windows

Windows versions since Vista have a feature in which files with administrative privileges in `Program Files` and other folders, may be masked by a version of the file in user's Virtual Store. The Virtual Store is located at `C:\Users\User_name\AppData\Local\VirtualStore`.

If you have changed a file under Program Files using administrative privileges, but find the changes mysteriously fail to have any effect, the Virtual Store may be to blame. I noticed this when editing Wireshark's `init.lua` file, but the changes would have no effect. I was able to fix the problem by editing the file stored at the Virtual Store location mentioned above. Certain editors are aware of this Windows feature. When opening and saving a privileged file they use the Virtual Store without informing the user.
