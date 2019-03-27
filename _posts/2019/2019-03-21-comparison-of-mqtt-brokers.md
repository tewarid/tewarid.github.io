---
layout: default
title: Comparison of MQTT Brokers
tags: mqtt broker comparison
comments: true
---
# Comparison of MQTT Brokers

|         Feature         |          ActiveMQ           |       ActiveMQ Artemis       |     HiveMQ     |     JoramMQ      |     Mosquitto     |            RabbitMQ            |       VerneMQ        |
| :---------------------- | :-------------------------: | :--------------------------: | :------------: | :--------------: | :---------------: | :----------------------------: | :------------------: |
| Open source             |         Apache 2.0          |          Apache 2.0          |   Commercial   | LGPL, Commercial |      EPL/EDL      |            MPL 1.1             |      Apache 2.0      |
| Commercial support      |             YES             |             YES              |     HiveMQ     |    ScalAgent     |       TIBCO       |            Pivotal             |    Octavo Labs AG    |
| Docker container        |       rmohr/activemq        |   vromero/activemq-artemis   | hivemq/hivemq3 |        NO        | eclipse-mosquitto |           rabbitmq:3           | erlio/docker-vernemq |
| Windows release         |             YES             |             YES              |      YES       |       YES        |        YES        |              YES               |          NO          |
| MQTT version            |            3.1.1            |            3.1.1             |  3.x and 5.0   |       3.x        |       3.1.1       |             3.1.1              |     3.x and 5.0      |
| AMQP version            |             1.0             |             1.0              |       NA       |    0.9.1, 1.0    |        NA         |        0.8, 0.9.x, 1.0         |          NA          |
| AMQP interoperability   |             NO              |              NO              |       NA       |        NO        |        NA         | Partial ([see note 1](#notes)) |          NA          |
| MQTT over WebSocket     |             YES             |             YES              |      YES       |       YES        |        YES        |              YES               |         YES          |
| Retain flag             |             YES             |             YES              |      YES       |       YES        |        YES        | Partial ([see note 2](#notes)) |         YES          |
| Last will and testament |             YES             |             YES              |      YES       |       YES        |        YES        |              YES               |         YES          |
| Persistent Session      |             YES             |             YES              |      YES       |       YES        |        YES        |              YES               |         YES          |
| QoS Level 1             |             YES             |             YES              |      YES       |       YES        |        YES        |              YES               |         YES          |
| QoS Level 2             |             YES             |             YES              |      YES       |       YES        |        YES        |               NO               |         YES          |
| Bridging                |             NO              |              NO              |      YES       |       YES        |        YES        |               NO               |         YES          |
| Clustering              |             YES             |             YES              |      YES       |       YES        |        NO         |              YES               |         YES          |
| Management interface    |        WEB, HTTP API        |        WEB, HTTP API         |      YES       |  jorammq-admin   |  mosquitto.conf   |        WEB, rabbitmqctl        | HTTP API, vmq-admin  |
| Latest version          | 5.15 ([see note 3](#notes)) | 2.7.0 ([see note 3](#notes)) |       4        |       5.16       |       1.5.8       |             3.7.13             |        1.7.1         |
| GitHub likes            |            1.4K             |             0.5K             |       NA       |        NA        |       2.4K        |              5.4K              |         1.7K         |

## Notes

1. See [MQTT and AMQP 1.0 interoperability in RabbitMQ]({% link _posts/2019/2019-03-13-mqtt-and-amqp-1.0-interoperability-in-rabbitmq.md %}).
2. If a client was offline when a retained message was sent to a topic, it is not received when the client subsequently subscribes to the topic with wildcards.
3. ActiveMQ version 6 will be based on Artemis which is based on JBoss Hornett and currently distributed as a separate product.
4. A comparison with additional brokers is available at https://github.com/mqtt/mqtt.github.io/wiki/server-support.
