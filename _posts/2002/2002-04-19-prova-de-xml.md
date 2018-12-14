---
layout: default
title: Prova de XML
tags: xml xsl xsd dtd prova
comments: true
languages:
  - pt
---

Veja gabarito no final.

1. O que significa a sigla XML?  
a. eXtensible Markup Language  
b. eXtra Markup Language  
c. eXample Markup Language  
d. XhtML

2. Para definir o tipo de um documento XML podemos utilizar?  
a. XSL  
b. Esquema  
c. DTD  
d. Todas as opções em cima

3. Qual é a forma correta de declarar a versão da XML utilizada pelo um documento?  
a. `<?xml version="1.0"/>`  
b. `<?xml version="1.0"?>`  
c. `<xml version="1.0"/>`  

4. Qual das opções a seguir são válidas?  
a. Nome de todos os elementos XML deveriam ser em minúsculo  
b. Todos os elementos deveriam ter o marcador de fechamento  
c. Todos os documentos XML deveriam conter uma DTD  
d. Todas as opções em cima  

5. Qual das opções a seguir são válidas?  
a. Cada documento XML deveria ter um marcador raiz  
b. Elementos XML deveriam ser corretamente aninhados  
c. Marcador XML é sensível ao caso  
d. Todas as opções em cima  

6. O documento XML a seguir está correto?  
    ```xml
    <?xml version="1.0"?>
    <nota>
    <de idade=29>Maria</de>
    <para>Jani</para>
    </nota>
    ```

    a. Verdadeiro  
    b. Falso  

7. Escolha os nomes de elementos inválidos?  
a. `<Nota>`  
b. `<xmldocumento>`  
c. `<17agosto>`  
d. `<data pedido>`  

8. Qual é a forma correta para avisar um leitor a ignorar algum texto no documento XML?  
a. `<CDATA> Texto para ignorar </CDATA>`  
b. `<PCDATA> Texto para ignorar </PCDATA>`  
c. `<![CDATA[ Texto para ignorar ]]>`  
d. `<xml:CDATA[ Texto para ignorar ]>`

9. Qual das opções a seguir estão corretas?  
a. Com a DTD podemos restringir o valor texto de um atributo  
b. Com a DTD podemos especificar relacionamentos entre elementos  
c. Com a DTD podemos restringir o valor texto de um elemento  
d. Todas as opções em cima  

10. Notações são utilizadas para  
a. Criar elementos  
b. Criar atributos  
c. Especificar processadores externos para conteúdo não XML  
d. Criar texto reutilizável  

11. Qual é a sintaxe correta para declarar um novo tipo de elemento sem conteúdo?  
a. `<!ELEMENT livro ANY>`  
b. `<!ELEMENT livro (EMPTY)>`  
c. `<!ELEMENT livro EMPTY>`  
d. `<!ELEMENT livro (ANY)>`  

12. Esquema XML e DTD não podem ser utilizados juntos  
a. Verdadeiro  
b. Falso  

13. Um tipo complexo pode ser usado para  
a. Declarar novos elementos  
b. Declarar novos atributos  
c. Definir outros tipos complexos  
d. Todas as opções em cima  

14. Um tipo simples pode ser usado para  
a. Declarar novos elementos  
b. Declarar novos atributos  
c. Definir outros tipos complexos  
d. Todas as opções em cima  

15. Um documento XML no DOM é representado pelo objeto  
a. Element  
b. Node  
c. Attr  
d. Document  

16. Que objetos do DOM herdam do objeto Node:  
a. Element  
b. Attr  
c. Document  
d. Todas as opções em cima.

17. SAX é uma API baseada em  
a. Propriedades  
b. Eventos  
c. Pull  
d. Push  

18. XSLT é utilizada para  
a. Transformar documento XML para HTML  
b. Transformar documento XML para XML  
c. Transformar documento XML para Texto  
d. Transformar documento XML para PDF

19. Para inserir o caractere reservado `<` podemos usar a entidade  
a. `&lt;`  
b. `&gt;`  
c. `&amp;`  
d. `&quot;`

20. Para que o código XSLT a seguir  
    ```xsl
    <xsl:text disable-output-escaping="?">Editora A &amp; B</xsl:text>
    ```
    Gere o texto a seguir na saída
    ```text
    Editora A & B
    ```
    Qual deveria ser o valor do atributo disable-output-escaping?  
    a. no  
    b. yes  

21. Para associar uma folha de estilo em cascata ao documento XML podemos usar  
a. `<?xml-stylesheet href="teste.xsl" type="text/xsl"?>`  
b. `<?stylesheet href="teste.css" type="text/css"?>`  
c. `<?xml-stylesheet href="teste.css" type="text/css"?>`  
d. `<?link href="teste.css" type="text/css"?>`

22. Para especificar a chave primária dentro de um esquema, utilizamos  
a. XLINK  
b. XPOINTER  
c. XPATH  
d. XHTML

23. Em XPATH, para selecionar o nó raiz usamos  
a. .  
b. /  
c. //  
d. *

24. O comando xsl:sort pode ser usado dentro dos comandos  
a. `xsl:apply-templates`  
b. `xsl:for-each`  
c. `xsl:template`  
d. Todas as opções em cima

25. Para importar um arquivo XSLT dentro do outro podemos usar  
a. `xsl:import`  
b. `xsl:use`  
c. `xsl:include`  
d. `xsl:apply`

26. Para chamar um template nomeado usamos o comando  
a. `xsl:call-template`  
b. `xsl:apply-templates`  
c. `xsl:template`  
d. `xsl:use-template`

27. Para passar parâmetros do mundo externo para uma folha de estilo XSL podemos usar o elemento  
a. `xsl:parameter`  
b. `xsl:variable`  
c. `xsl:param`  
d. `xsl:option`

28. A CSS é utilizada para  
a. Visualizar um documento XML  
b. Transformar um documento XML  
c. Gerar HTML a partir do documento XML  
d. Reorganizar um documento XML

29. JDOM dispensa o uso de um parser DOM ou SAX  
a. Verdadeiro  
b. Falso  

30. O curinga `<xs:any/>` quer dizer que qualquer elemento de qualquer espaço identificador pode aparacer dentro do elemento  
a. Verdadeiro  
b. Falso  

31. O exemplo a seguir é um exemplo válido de definição de tipo complexo  
    ```xsd
    <xs:complexType name="tipoLivro">
        <xs:sequence>
            <xs:element name="autor" type="xs:string"/>
            <xs:attribute name="nome" type="xs:string"/>
        </xs:sequence>
    </xs:complexType>
    ```
    a. Verdadeiro  
    b. Falso

32. SAX é uma especificação do W3C  
a. Verdadeiro  
b. Falso  

33. Atributos não formam parte da árvore gerado pelo parser DOM  
a. Verdadeiro  
b. Falso  

34. Padrão Esquema XML tem suporte para tipos de dados utilizados nas linguagens de programação  
a. Verdadeiro  
b. Falso  

35. DTD tem suporte completo para espaços identificadores (namespaces)  
a. Verdadeiro  
b. Falso  

36. Num esquema podemos utilizar quais das opções a seguir para especificar que podem ocorrer infinitas ocorrências de um elemento  
a. `maxOccurs="unbounded"`  
b. `maximumOccurs="unbounded"`  
c. `maxOccurs="infinite"`  
d. Nenhuma das opções em cima

37. Se um esquema XML iniciar com o elemento a seguir, como podemos declarar um elemento ou atributo do tipo texto  
    ```xsd
    <schema xmlns="http://www.w3.org/2001/XMLSchema">
    ```
    a. `type="xs:string"`  
    b. `type="STRING"`  
    c. `type="xs:text"`  
    d. `type="string"`

38. Para um elemento declarado como  
    ```xsd
    <xs:element name="livro">
        <xs:complexType>
            <xs:choice minOccurs="0" maxOccurs="unbounded">
                <xs:element name="autor"/>
                <xs:element name="autora"/>
            </xs:choice>
            <xs:attribute name="nome" type="xs:string"/>
        </xs:complexType>
    </xs:element>
    ```
    O documento XML a seguir está correto
    ```xml
    <livro nome="Nome do Livro">
        <autor>autor1</autor>
        <autor>autor2</autor>
        <autora>autora1</autora>
    </livro>
    ```
    a. Verdadeiro  
    b. Falso  

39. O elemento raiz a seguir está válido considerando que o documento XML utiliza para definição do seu tipo um esquema chamado catalogo.xsd com targetNamespace http://www.exemplo.org/catalogo  
    ```xml
    <catalogo xmlns="http://www.w3.org/2001/XMLSchema-instance" 
    noNamespaceSchemaLocation="catalogo.xsd" 
    xmlns="http://www.exemplo.org/catalogo">
    ```
    a. Verdadeiro  
    b. Falso  

40. Considere um documento XML a seguir:  
    ```xml
    <livro nome="DEF">
        <autor>ABC</autor>
        <autor>XYZ</autor>
    </livro>
    ```
    Se utilizarmos o template a seguir para transformar o documento
    ```xsl
    <xsl:template match="livro">
        <xsl:if test="autor[text()='XYZ']">
            <xsl:value-of select="@nome"/>
        </xsl:if>
    </xsl:template>
    ```
    Qual é a saída esperada?  
    a. ABC  
    b. DEF  
    c. XYZ  
    d. Não vai aparecer nada na saída

### Gabarito

1a 2bc 3b 4b 5d 6b 7bcd 8c 9ab 10c 11c 12b 13ac 14d 15d 16d 17bd 18abc 19a 20b 21c 22c 23b 24ab 25ac 26a 27c 28a 29b 30b 31b 32b 33a 34a 35b 36a 37d 38a 39b 40b
