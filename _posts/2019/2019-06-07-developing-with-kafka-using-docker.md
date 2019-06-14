---
layout: default
title: Developing with Kafka using Docker
tags: kafka docker compose zookeeper bitnami
comments: true
---
# Developing with Kafka using Docker

Cloud-first development with Kafka is becoming easier with every cloud platform providing a service of the kind, and even a few dedicated to Kafka alone such as [cloudkarafka](https://www.cloudkarafka.com/). In this post, I share a compose file to run Kafka in Docker for development and testing.

The following compose file runs Kafka and Zookeeper in a private bridge network. Add your own services to the file and they will be able to use Kafka at host address `kafka` and (the default) port `9092`.

```yaml
version: '2'
networks:
  app-tier:
    driver: bridge
services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes
    networks:
      - app-tier
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '29092:29092'
    environment:
      - KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://:9092,PLAINTEXT_HOST://:29092
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:29092
    networks:
      - app-tier
```

The compose file also [exposes Kafka on the host](https://github.com/bitnami/bitnami-docker-kafka/issues/21#issuecomment-435216317) at address `localhost` and port `29092`. For additional options such as volume mapping head over to [GitHub](https://github.com/bitnami/bitnami-docker-kafka).

To launch the containers, run

```bash
docker-compose up -d
```

To test Kafka broker from host OS such as Windows, [download Kafka binary](https://kafka.apache.org/downloads), and run console consumer

```cmd
.\kafka_2.11-2.2.1\bin\windows\kafka-console-consumer.bat --bootstrap-server localhost:29092 --topic test
```

And publisher

```cmd
.\kafka_2.11-2.2.1\bin\windows\kafka-console-producer.bat --broker-list localhost:29092 --topic test
```
