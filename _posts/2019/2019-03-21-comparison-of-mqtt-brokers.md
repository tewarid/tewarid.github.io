---
layout: default
title: Comparison of MQTT Brokers
tags: mqtt broker comparison
comments: true
---
# Comparison of MQTT Brokers

|         Feature         |                    ActiveMQ                    |              HiveMQ              |                  Joram                  |     Mosquitto     |                                            RabbitMQ                                            |       VerneMQ        |
| :---------------------- | :--------------------------------------------: | :------------------------------: | :-------------------------------------: | :---------------: | :--------------------------------------------------------------------------------------------: | :------------------: |
| Open source             |                   Apache 2.0                   |            Commercial            |            LGPL, Commercial             |      EPL/EDL      |                                            MPL 1.1                                             |      Apache 2.0      |
| Commercial support      | [YES](http://activemq.apache.org/support.html) | [HiveMQ](https://www.hivemq.com) | [ScalAgent](https://www.scalagent.com/) |       TIBCO       |                                            Pivotal                                             |    Octavo Labs AG    |
| Docker container        |                 rmohr/activemq                 |          hivemq/hivemq3          |                   NO                    | eclipse-mosquitto |                                           rabbitmq:3                                           | erlio/docker-vernemq |
| Windows release         |                      YES                       |               YES                |                   YES                   |        YES        |                                              YES                                               |          NO          |
| MQTT version            |                     3.1.1                      |           3.x and 5.0            |                   3.x                   |       3.1.1       |                                             3.1.1                                              |     3.x and 5.0      |
| AMQP version            |                      1.0                       |                NA                |               0.9.1, 1.0                |        NA         |                                        0.8, 0.9.x, 1.0                                         |          NA          |
| AMQP interoperability   |                                                |                NA                |                                         |        NA         | [Partial]({% link _posts/2019/2019-03-13-mqtt-and-amqp-1.0-interoperability-in-rabbitmq.md %}) |                      |
| MQTT over WebSocket     |                      YES                       |               YES                |                   YES                   |        YES        |                                              YES                                               |         YES          |
| Retain flag             |                      YES                       |               YES                |                                         |        YES        |                                 Partial ([see note 1](#notes))                                 |         YES          |
| Last will and testament |                      YES                       |               YES                |                                         |        YES        |                                              YES                                               |         YES          |
| Persistent Session      |                      YES                       |               YES                |                                         |        YES        |                                              YES                                               |         YES          |
| QoS Level 1             |                      YES                       |               YES                |                   YES                   |        YES        |                                              YES                                               |         YES          |
| QoS Level 2             |                      YES                       |               YES                |                   YES                   |        YES        |                                               NO                                               |         YES          |
| Message persistence     |                      YES                       |               YES                |                                         |        YES        |                                              YES                                               |         YES          |
| High availability       |                      YES                       |               YES                |                                         |        YES        |                                              YES                                               |         YES          |
| Management interface    |                 WEB, HTTP API                  |               YES                |                                         |  mosquitto.conf   |                                        WEB, rabbitmqctl                                        | HTTP API, vmq-admin  |
| Latest version          |          5.15 ([see note 2](#notes))           |                4                 |                  5.16                   |       1.5.8       |                                             3.7.13                                             |        1.7.1         |
| GitHub likes            |                      1.4K                      |                NA                |                   NA                    |       2.4K        |                                              5.4K                                              |         1.7K         |

## Notes

1. If a client was offline when a retained message was sent to a topic, it is not received when the client subsequently subscribes to the topic with wildcards
2. ActiveMQ version 6 may be based on Artemis which is based on JBoss Hornett and currently distributed as a separate product.
