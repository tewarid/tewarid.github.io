---
layout: default
title: WebSockets with WCF
tags: websocket wcf c# .net programming
comments: true
---
# WebSockets with WCF

This post demonstrates an elementary chat service constructed using WCF and WebSockets. A custom binding that leverages WebSocket support in [httpTransport](https://docs.microsoft.com/en-us/dotnet/framework/configure-apps/file-schema/wcf/httptransport) is used. JSON is serialized and deserialized using byteStreamMessageEncoding encoding. Use httpsTransport for secure transport.

## Service interface

The service interface is used to receive connection requests and messages from clients. It has only one method, as shown below.

```c#
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading.Tasks;

namespace ChatService
{
    [ServiceContract(CallbackContract = typeof(IChatServiceCallback))]
    interface IChatService
    {
        [OperationContract(IsOneWay = true, Action = "*")]
        Task SendMessage(Message message);
    }
}
```

## Callback interface

The callback interface is used to send messages back to the clients.

```c#
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading.Tasks;

namespace ChatService
{
    [ServiceContract]
    interface IChatServiceCallback
    {
        [OperationContract(IsOneWay = true, Action = "*")]
        Task ReceiveMessage(Message message);
    }
}
```

## Service implementation

The service implementation receives messages from clients, and fires them off to other clients, using their respective callback interface. Messages are sent to clients who have sent messages to a chat room, and are still connected.

```c#
using System;
using System.Collections.Concurrent;
using System.IO;
using System.Net.WebSockets;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading.Tasks;

namespace ChatService
{
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    public class ChatServiceImplementation : IChatService
    {
        static ConcurrentDictionary<string, ConcurrentDictionary<string, Chatter>> rooms = 
            new ConcurrentDictionary<string, ConcurrentDictionary<string, Chatter>>();

        public async Task SendMessage(Message message)
        {
            if (message.IsEmpty) return;

            byte[] body = message.GetBody<byte[]>();
            MemoryStream stream = new MemoryStream(body);
            DataContractJsonSerializer ser = new DataContractJsonSerializer(typeof(Chatter));
            Chatter chatter = (Chatter)ser.ReadObject(stream);
            IChatServiceCallback callback = OperationContext.Current.GetCallbackChannel<IChatServiceCallback>();
            chatter.Callback = callback;

            IChannel channel = (IChannel)callback;
            channel.Faulted += channel_Faulted;
            channel.Closed += channel_Closed;

            ConcurrentDictionary<string, Chatter> room;
            if (!rooms.TryGetValue(chatter.Room, out room))
            {
                room = new ConcurrentDictionary<string, Chatter>();
                rooms.TryAdd(chatter.Room, room);
            }
            Chatter existingChatter;
            if (!room.TryGetValue(chatter.Nickname, out existingChatter))
            {
                room.TryAdd(chatter.Nickname, chatter);
            }
            else if (existingChatter.Callback != chatter.Callback)
            {
                existingChatter.Callback = chatter.Callback;
            }
            foreach (Chatter c in room.Values)
            {
                if (((IChannel)c.Callback).State == CommunicationState.Opened)
                    await c.Callback.ReceiveMessage(CreateMessage(body));
            }
        }

        private void channel_Closed(object sender, EventArgs e)
        {
            // Clean up
        }

        private void channel_Faulted(object sender, EventArgs e)
        {
            // Clean up
        }

        private Message CreateMessage(byte[] message)
        {
            Message channelMessage = ByteStreamMessage.CreateMessage(new ArraySegment<byte>(message));

            channelMessage.Properties["WebSocketMessageProperty"] =
                new WebSocketMessageProperty { MessageType = WebSocketMessageType.Text };

            return channelMessage;
        }
    }
}
```

Here's the Chatter class, used to store state.

```c#
using System.Runtime.Serialization;

namespace ChatService
{
    [DataContract()]
    class Chatter : IExtensibleDataObject
    {
        [DataMember(Name = "nickname", IsRequired = true)]
        public string Nickname { get; set; }
        [DataMember(Name = "room", IsRequired = true)]
        public string Room { get; set; }
        [DataMember(Name = "message", IsRequired = true)]
        public string Message { get; set; }
        public IChatServiceCallback Callback { get; set; }

        public ExtensionDataObject ExtensionData { get; set; }
    }
}
```

## App.config

App.config below creates a customBinding and associates it with the chat service.

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.serviceModel>
    <bindings>
      <customBinding>
        <binding name="webSocketHttpBinding">
          <byteStreamMessageEncoding/>
          <httpTransport>
            <webSocketSettings transportUsage="Always" createNotificationOnConnection="true"/>
          </httpTransport>
        </binding>
      </customBinding>
    </bindings>
    <services>
      <service name="ChatService.ChatServiceImplementation">
        <endpoint address="http://localhost:8004/chatservice" binding="customBinding" bindingConfiguration="webSocketHttpBinding" contract="ChatService.IChatService"/>
      </service>
    </services>
  </system.serviceModel>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.5"/>
  </startup>
</configuration>
```

## Self hosted console app

A console app that hosts the service is shown below.

```c#
using System;
using System.ServiceModel;

namespace ChatServiceHost
{
    class Program
    {
        static void Main(string[] args)
        {
            ServiceHost host = new ServiceHost(typeof(ChatService.ChatServiceImplementation));
            host.Open();

            Console.WriteLine("Hit Enter to quit.");
            Console.ReadLine();
        }
    }
}
```

## Chat web page

The following web page uses jQuery and WebSocket to send/receive messages to/from chat rooms.

```html
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title>Chat</title>
    <script type="text/javascript"
            src="https://code.jquery.com/jquery-2.1.4.min.js">
    </script>
</head>
<body>
    <form>
        Nickname <br/>
        <input id="nickname" type="text" value="nickname" /><br/>
        Room 

        <input id="room" type="text" value="room" /><br/>
        Message 

        <input id="message" type="text" value="message" /><br/>
        <input id="send" type="button" value="Send" />
    </form>

    <p>
        Messages
        <div id="messages">

        </div>
    </p>
    <img src="image/HTML5_Logo_64.png" />

    <script type="text/javascript">
        var url = 'ws://localhost:8004/chatservice'; // base url
        var connection = null;
        $(document).ready(documentReady);
        function documentReady() {
            $("#send").click(sendClick);
        }
        function sendClick() {
            if (connection == null) {
                connection = new WebSocket(url);
            } else {
                sendMessage();
                return;
            }
            connection.onopen = sendMessage;
            connection.onmessage = receiveMessage;
            connection.onerror = function (e) {
                alert('error ' + e);
                connection = null;
            };
        }

        function sendMessage() {
            var chatter = new Object();
            chatter.nickname = $('#nickname').val();
            chatter.room = $('#room').val();
            chatter.message = $('#message').val();
            connection.send(JSON.stringify(chatter));
        }
        function receiveMessage(e) {
            var chatter = JSON.parse(e.data);
            var message = chatter.nickname + '@' + chatter.room + ' said ' + chatter.message + '<br/>';
            $('#messages').prepend(message);
        }
    </script></body>
</html>
```

## Testing

Open the HTML file in a modern web browser, and you'll see the chat page. Open the same page in additional tabs. Once you send a message to one or more chat rooms in a tab, messages posted from other tabs using different nicknames to the same chat rooms, should appear in the Messages area in reverse chronological order.

One really pesky problem is the following exception you get, when you try to send the same Message instance to multiple callbacks

```text
A property with the name 'TransactionFlowProperty' already exists.
```

I have also experimented with testing scalability by hitting the service using [thor](https://github.com/observing/thor), and have noted that `InstanceContextMode.Single` behavior is the most responsive and reliable.

I'd like to acknowledge Zhuyun Dai's [article](http://www.codeproject.com/Articles/619343/Using-WebSocket-in-NET-Part) at CodeProject for giving useful insights with regards to using byteStreamMessageEncoding.
