---
layout: default
title: Use semistandard to lint TypeScript code
tags: .net core asp.net docker multistage
comments: true
---
# Use semistandard to lint TypeScript code

semistandard is a fork of standard thats allows semicolons at end of statements. The following Docker file illustrates how to run semistandard using Docker

```Dockerfile
FROM node:lts-alpine AS base
RUN  mkdir /src
COPY ./src /src
RUN npm config set unsafe-perm true
RUN npm install -g semistandard @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint typescript
RUN semistandard --parser @typescript-eslint/parser --plugin @typescript-eslint/eslint-plugin /src/MyService/ClientApp/**/*/*.ts
```

`npm config set unsafe-perm true` [works around an issue](https://stackoverflow.com/questions/52196518/could-not-get-uid-gid-when-building-node-docker) where npm fails to get gid/uid in certain environments.

To lint your own code, change `./src` and `/src/MyService/ClientApp` appropriately.

Test code may [fail to lint](https://github.com/standard/standard/issues/18) with errors such as

```text
semistandard: Semicolons For All! (https://github.com/Flet/semistandard)
  /src/MyService/ClientApp/src/test/test.ts:3:1: 'it' is not defined.
The command '/bin/sh -c semistandard --parser @typescript-eslint/parser --plugin @typescript-eslint/eslint-plugin /src/MyService/ClientApp/**/*/*.ts' returned a non-zero code: 1
```

To fix it, you can add the following to top of each test file

```typescript
/* eslint-env mocha */
```
