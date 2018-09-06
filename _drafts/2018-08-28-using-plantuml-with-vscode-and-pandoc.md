---
layout: default
title: Using PlantUML with VSCode and Pandoc
tags: markdown pandoc plantuml uml
---

Java
https://gitlab.com/graphviz/graphviz/ (brew install graphviz on macos)

### Editing in VSCode

https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml

```plantuml
@startuml
Alice -> Bob: Authentication Request Bob --> Alice: Authentication Response
Alice -> Bob: Another authentication Request Alice <-- Bob: another authentication Response
@enduml
```

### Using with Pandoc

https://github.com/plantuml/plantuml
https://github.com/pandoc/lua-filters/tree/master/plantuml
