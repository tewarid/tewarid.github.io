---
layout: default
title: "Modelo Visão Controlador"
tags: mvc
comments: true
languages:
  - pt
---

O padrão MVC isola as responsabilidades de um aplicativo em tres partes para facilitar o desenvolvimento.

<div class="mermaid" style="height:200px;">
graph LR
    Visão --> Modelo
    Visão --> Controlador
    Controlador --> Visão
    Controlador --> Modelo
    Modelo -.-> Visão
</div>

### Modelo

O modelo contém a funcionalidade central do aplicativo e encapsula o estado do mesmo. As vezes, como no caso de uma base de dados, a única funcionalidade contida é o estado. O modelo desconhece a visão e o controlador.

### Visão

A visão é responsável pela aparência do aplicativo, tem acesso aos dados do modelo, mas não pode atualizar o modelo. A visão precisa ser avisada quando o modelo for alterado.

### Controlador

O controlador reage a entrada do usuário e atualiza o modelo.

### Exemplo

Considere o caso de um relógio. A função central de qualquer relógio é manter o horário. Isso seria o modelo. A visão seria responsável por apresentar o horário do relógio, seja de forma digital, analógica ou outra qualquer. O controlador seria o receptor da entrada do usuário a partir dos botões, para atualizar o modelo. A atualização do modelo altera a visão.
