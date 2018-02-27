---
layout: default
title: Write Ubuntu image file to SD card on Windows
tags: ubuntu image pandaboard sd card linux
---

I use an 8 GB class 4 SD Card to run the Ubuntu distribution for OMAP4 on a [PandaBoard](https://en.wikipedia.org/wiki/PandaBoard). This post details the procedure I use to prepare the SD Card on Windows.

### Download and write Ubuntu image

You'll need the following tools

1. [7-zip](http://www.7-zip.org/) or other decompressor that can extract gzipped file (extension gz).
2. [Win32 Disk Imager](http://sourceforge.net/projects/win32diskimager/) to write the img file to the SD Card.
3. A laptop with SD Card reader, or an external USB SD Card reader.

Here's the procedure to prepare the SD Card

1. [Download](https://wiki.ubuntu.com/ARM/OMAP) Ubuntu gzipped image file for OMAP4 boards
2. Extract img file using 7-zip
3. Insert SD Card into reader
4. Execute `Win32DiskImager.exe` - it requests admin privileges on Windows 7
5. Select the image file extracted in step 2
6. Select the device that corresponds to the SD Card reader
7. Write the image file - this will take a while
8. Eject the SD Card

### Backup or Clone SD Card

Win32 Disk Imager can also be used to read an SD Card. You can write the image file to the same or another SD Card.

### Restore SD Card to Original State

The SD Card will be partitioned after the procedure above. To restore it to its original state i.e. create a single partition with all the available space, you'll need to use the GParted Partition Editor on a Linux box, or from a [live CD](http://gparted.sourceforge.net/livecd.php). Windows 8 Disk Management tool may also work.

### Patch for version 0.3 of Win32 Disk Imager

Version 0.3 binary of Win32 Disk Imager has a bug in a call to Win32 `[SetFilePointer](http://msdn.microsoft.com/en-us/library/aa365541.aspx)` function. The image read is about half the size of my 8 GB SD Card. I built it from source using [QT Creator](http://qt-project.org/wiki/Category:Tools::QtCreator) after patching the following two functions in `disk.cpp`

```c
char *readSectorDataFromHandle(HANDLE handle, unsigned long long startsector, unsigned long long numsectors, unsigned long long sectorsize)
{
    unsigned long bytesread;
    char *data = new char[sectorsize * numsectors];
    LARGE_INTEGER li;
    li.QuadPart = startsector * sectorsize;
    SetFilePointer(handle, li.LowPart, &li.HighPart, FILE_BEGIN);
    if (!ReadFile(handle, data, sectorsize * numsectors, &bytesread, NULL))
    {
        char *errormessage=NULL;
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER, NULL, GetLastError(), 0, (LPSTR)&errormessage, 0, NULL);
        QMessageBox::critical(NULL, "Read Error", QString("An error occurred when attempting to read data from handle.\nError %1: %2").arg(GetLastError()).arg(errormessage));
        LocalFree(errormessage);
        delete data;
        data = NULL;
    }
    return data;
}

bool writeSectorDataToHandle(HANDLE handle, char *data, unsigned long long startsector, unsigned long long numsectors, unsigned long long sectorsize)
{
    unsigned long byteswritten;
    BOOL bResult;
    LARGE_INTEGER li;
    li.QuadPart = startsector * sectorsize;
    SetFilePointer(handle, li.LowPart, &li.HighPart, FILE_BEGIN);
    bResult = WriteFile(handle, data, sectorsize * numsectors, &byteswritten, NULL);
    if (!bResult)
    {
        char *errormessage=NULL;
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER, NULL, GetLastError(), 0, (LPSTR)&errormessage, 0, NULL);
        QMessageBox::critical(NULL, "Write Error", QString("An error occurred when attempting to write data from handle.\nError %1: %2").arg(GetLastError()).arg(errormessage));
        LocalFree(errormessage);
    }
    return (bResult == TRUE);
}
```

That fixes the problem with reading and writing large SD Cards.
