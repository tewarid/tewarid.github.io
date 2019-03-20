---
layout: default
title: MQTT and AMQP 1.0 interoperability in RabbitMQ
tags: mqtt rabbitmq amqp
comments: true
---
# MQTT 3.1.1 and AMQP 1.0 interoperability in RabbitMQ

RabbitMQ's [AMQP 1.0 plugin](https://github.com/rabbitmq/rabbitmq-amqp1.0) can be used by applications to communicate with devices that use the MQTT 3.1.1 protocol. You need to use the [appropriate AMQP 1.0 link address](https://github.com/rabbitmq/rabbitmq-amqp1.0#routing-and-addressing) so that RabbitMQ is able to route the messages through the `amq.topic` exchange used for the MQTT protocol.

An AMQP sender can send a message to an MQTT topic such as `1/temperature` using address `/topic/1.temperature` and subject `1.temperature`. The `/topic/` prefix indicates that the `amq.topic` exchange is used. That exchange routes a message to all the linked AMQP receivers. The default AMQP exchange routes a message to linked receivers in a round robin fashion, so only one receiver picks up the message for processing. 

An AMQP receiver can receive message sent to an MQTT topic such as `+/temperature` using address `/topic/*.temperature`. The multi-level wildcard symbol `#` may also be used. A receiver can receive all messages sent to the `amq.topic` exchange using address `/topic/#`.

An MQTT client can publish a message to a topic with retain flag set, and MQTT clients that are currently offline can receive the message when they subscribe to the topic later&mdash;as long as the subscription topic [does not contain wildcards](https://groups.google.com/d/msg/mqtt/IX11ctC1vvE/mmCBlavdBgAJ) e.g. subscribing to `#` topic will not deliver retained messages. Other brokers such as Mosquitto don't have this limitation. RabbitMQ [does not allow AMQP 1.0 sender](https://groups.google.com/d/topic/rabbitmq-users/unSIk-yueh4/discussion) to send message with retain flag set. Another downside is that messages sent by MQTT client with retain flag set are not received by AMQP 1.0 receivers that are currently offline.
