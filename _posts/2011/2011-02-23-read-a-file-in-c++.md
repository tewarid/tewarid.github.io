---
layout: default
title: Read a file in C++
tags: c++ cpp read file
comments: true
---

I have returned to C++ programming. In the past I have read about it and practiced it as a theoretical exercise, but never for anything serious beyond that.

I was recently looking for a way to read a file, and that simple task turned into an arduous affair. Since I am using VC++ my first thought was to lookup documentation on the fstream library, but that is not easy since members are split across [basic_istream](http://msdn.microsoft.com/en-us/library/bf670b2d.aspx), [basic_ios](http://msdn.microsoft.com/en-us/library/h6y46td1.aspx) and [basic_fstream](http://msdn.microsoft.com/en-us/library/ss211x23.aspx).

Eventually, I managed to create a basic example

```cpp
#include <string>
#include <fstream>
#include <iostream>
using namespace std;

const int gBufSize = 1024;
string filename = "file.bin";

int main( int argc, char *argv[] )
{
    char* buf[1024];
    streamsize n;
    ifstream binfile;

    binfile.open(filename);

    if (!binfile.is_open() || binfile.bad()) return -1;

    binfile.read((char*)buf, gBufSize);
    n = binfile.gcount();
    cout << "Read " << n << " bytes" << endl;

    while (n == gBufSize)
    {
        binfile.read((char*)buf, gBufSize);
        n = binfile.gcount();
        cout << "Read " << n << " bytes" << endl;
    }

    // we're done
    binfile.close();

    return 0;
}
```
