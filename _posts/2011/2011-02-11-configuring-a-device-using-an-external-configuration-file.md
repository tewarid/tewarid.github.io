---
layout: default
title: Configuring a device using an external configuration file
tags:
comments: true
---

This post discusses a very simple scheme that I used to configure a TopCon GPS device by issuing commands from an external configuration file. This has the advantage of not requiring to recompile the app if you need to quickly change something. This pattern can be quite generally applied to configure any device that presents a command line interface.

Here's the code of a parser that reads the external config file

```c#
public class ConfigParser
{
    private StreamReader reader;

    public ConfigParser(string file)
    {
        reader = new StreamReader(File.Open(file, FileMode.Open));
    }

    /// Read the next command from the config file or null if
    /// no commands left to read
    public string NextCommand()
    {
        return ReadLine();
    }

    private string ReadLine() {
        StringBuilder line = new StringBuilder();
        int c;
        bool stop = false;
        bool inComment = false;
        while (!stop)
        {
            try
            {
                c = reader.Read();
            }
            catch
            {
                break;
            }
            switch (c)
            {
                case '\r':
                case '\n':
                case -1:
                    if (line.Length > 0 || reader.EndOfStream)
                    {
                        stop = true;
                    }
                    break;
                case '\t':
                case ' ':
                    // ignore
                    break;
                case '/':
                    if (reader.Peek() == '*')
                    {
                        inComment = true;
                    }
                    else
                    {
                        if (!inComment)
                        {
                            line.Append((char)c);
                        }
                    }
                    break;
                case '*':
                    if (reader.Peek() == '/')
                    {
                        inComment = false;
                        reader.Read();
                    }
                    else
                    {
                        if (!inComment)
                        {
                            line.Append((char)c);
                        }
                    }
                    break;
                case '%':
                case '#':
                    DiscardTillEOL();
                    break;
                default:
                    if (!inComment)
                    {
                        line.Append((char)c);
                    }
                    break;
            }
        }
        string retVal = line.ToString();
        return retVal == String.Empty ? null : retVal;
    }

    private void DiscardTillEOL() {
        int c = reader.Peek();
        while (c != -1 && c != '\r' && c != '\n')
        {
            reader.Read();
            c = reader.Peek();
        }
    }
}
```

Here's a simple example of a config file. It uses C language syntax for comments. A single line comment beginning with a # char can also be used.

```c
/* reset device configuration */
init,/par/
/* NMEA version */
set,nmea/ver,v2.3
/* schedule periodic reception of data */
em,/dev/ser/a,/msg/nmea/GGA:1.0
```
