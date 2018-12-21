---
layout: default
title: Logging to Syslog using NLog
tags: nlog syslog .net c#
comments: true
---
# Logging to Syslog using NLog

[NLog](https://github.com/NLog/NLog)'s [Network]() [target](https://github.com/NLog/NLog/wiki/Targets) can be used to stream to [Syslog](https://tools.ietf.org/html/rfc5424), using a target definition such as

```xml
    <target xsi:type="Network"
            name="syslog"
            onOverflow="Split"
            newLine="false"
            lineEnding="None"
            layout="${literal:text=&lt;14&gt;1} ${shortdate:universalTime=true}T${time:universalTime=true}Z ${machinename} ${processname} ${processid} ${literal:text=-} ${literal:text=-} [${level:uppercase=true}] ${message}"
            maxMessageSize="65000"
            encoding="utf-8"
            connectionCacheSize="5"
            maxConnections="0"
            maxQueueSize="0"
            keepConnection="true"
            onConnectionOverflow="AllowNewConnnection"
            address="udp://127.0.0.1:514" />
```

Here's an example of a log entry written using that target

```text
<14>1 2018-06-01T13:18:47.5949Z DESKTOP-KUQ62LL MyTestApplication 10256 - - Some log message
```

One problem with this approach&mdash;as we've hardcoded syslog severity to informational&mdash;is that the log level does not get translated to a syslog severity.

To properly translate the severity, we can write a [custom renderer](https://github.com/NLog/NLog/wiki/How-to-write-a-custom-layout-renderer) for NLog such as

```csharp
    public enum SyslogFacility
    {
        UserLevelMessages = 1
    };

    public enum SyslogSeverity
    {
        Emergency = 0,      // system is unusable
        Alert = 1,          // action must be taken immediately
        Critical = 2,       // critical conditions
        Error = 3,          // error conditions
        Warning = 4,        // warning conditions
        Notice = 5,         // normal but significant condition
        Informational = 6,  // informational messages
        Debug = 7           // debug-level messages
    };

    [LayoutRenderer("syslogpriority")]
    public class SyslogPriorityRenderer : LayoutRenderer
    {
        Dictionary<NLog.LogLevel, SyslogSeverity> NLogLevelToSyslogSeverity =
            new Dictionary<NLog.LogLevel, SyslogSeverity>
            {
                { NLog.LogLevel.Debug, SyslogSeverity.Debug },
                { NLog.LogLevel.Error, SyslogSeverity.Error },
                { NLog.LogLevel.Fatal, SyslogSeverity.Critical },
                { NLog.LogLevel.Info, SyslogSeverity.Informational },
                { NLog.LogLevel.Trace, SyslogSeverity.Debug },
                { NLog.LogLevel.Warn, SyslogSeverity.Warning }
            };

        protected override void Append(StringBuilder builder, LogEventInfo logEvent)
        {
            builder.Append($"<{(int)SyslogFacility.UserLevelMessages * 8 + NLogLevelToSyslogSeverity[logEvent.Level]}>");
        }
    }
```

Next, we register our assembly so NLog can find the renderer, and modify the target's layout as shown

```xml
    <extensions>
        <add assembly="MyTestApplication" />
    </extensions>

    <target xsi:type="Network"
            name="syslog"
            onOverflow="Split"
            newLine="false"
            lineEnding="None"
            layout="${syslogpriority}${literal:text=1} ${shortdate:universalTime=true}T${time:universalTime=true}Z ${machinename} ${processname} ${processid} ${literal:text=-} ${literal:text=-} ${message}"
            maxMessageSize="65000"
            encoding="utf-8"
            connectionCacheSize="5"
            maxConnections="0"
            maxQueueSize="0"
            keepConnection="true"
            onConnectionOverflow="AllowNewConnnection"
            address="udp://127.0.0.1:514" />
```

This will produce a similar log entry as before for `LogLevel` `Info`, and will properly translate other levels using the `NLogLevelToSyslogSeverity` dictionary.

If the syslog facility discards messages that are too long, you may need to restrict the size of the message. This can be achieved&mdash;since NLog 4.4&mdash;using a lambda expression such as

```c#
    LayoutRenderer.Register("shortmessage", (logEvent) =>
        logEvent.Message.Substring(0, logEvent.Message.Length > 1000 ? 1000 : logEvent.Message.Length));
```

Now, when you use the renderer `{shortmessage}`, the message will be truncated to a 1000 bytes.
