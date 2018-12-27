---
layout: default
title: Driving Apache Velocity template engine using XML
tags: xml apache velocity template
comments: true
---
# Driving Apache Velocity template engine using XML

The [Apache Velocity Runner](#runvelocity.java) merges an XML document such as

```xml
<!DOCTYPE velocity SYSTEM "velocity.dtd">

<velocity>
    <template root="c:\java\velocity" file="HelloVelocity.txt"/>
    <output root="c:\java\velocity" file="HelloVelocity.out.txt"/>
    <context>
        <property name="Name" value="Devendra Tewari"/>
        <list name="lastaccesses">
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="31/12/2001 18:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="16/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
        </list>
    </context>
</velocity>
```

With a template such as

```text
Hello $Name!

Last $!{lastaccesses.size()} accesses:
#foreach($access in $lastaccesses)
    ${velocityCount}. $access.time from $access.computer
#end

$!silent
```

To produce the following output

```text
Hello Devendra Tewari!

Last 5 accesses:
    1. 12/12/2001 13:30 from abc
    2. 31/12/2001 18:30 from abc
    3. 12/12/2001 13:30 from abc
    4. 12/12/2001 13:30 from abc
    5. 16/12/2001 13:30 from abc

```

The XML document schema in DTD form is reproduced below

```xml
<?xml encoding="UTF-8" ?>
<!ELEMENT velocity (template,output,context)>
<!ELEMENT template EMPTY>
<!ATTLIST template 
    root CDATA #REQUIRED
    file CDATA #REQUIRED
>
<!ELEMENT output EMPTY>
<!ATTLIST output
    root CDATA #REQUIRED
    file CDATA #REQUIRED
>
<!-- velocity context -->
<!ELEMENT context (property | list)+>
<!-- name/value pairs are placed directly into the context -->
<!ELEMENT property EMPTY>
<!ATTLIST property
    name CDATA #REQUIRED
    value CDATA #REQUIRED
>
<!-- maps contain one or more name/value pairs -->
<!ELEMENT object (property)+>
<!-- lists contain one or more maps -->
<!ELEMENT list (object)+>
<!ATTLIST list
    name CDATA #REQUIRED
>
```

## RunVelocity.java

```java
package velocity;

import java.util.Properties;
import java.util.ArrayList;
import java.util.HashMap;

import java.io.File;
import java.io.Writer;
import java.io.FileWriter;

import javax.xml.parsers.*;
import org.w3c.dom.*;
import org.xml.sax.*;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.Template;
import org.apache.velocity.app.VelocityEngine;

public class RunVelocity {

    public RunVelocity() {
    }

    /**
     * @param args One or more velocity run file(s)
     */
    public static void main(String[] args) throws Exception {
        RunVelocity rv = new RunVelocity();
        rv.process(args);
        System.out.println("done.");
    }

    /**
     * Process run files.
     *
     * @param runFiles One or more velocity run file(s).
     */
    public void process(String[] runFiles) throws Exception {
        if (runFiles.length == 0) {
            System.out.println("Specify atleast one velocity run file.");
            System.out.println("Usage:");
            System.out.println("\tjava RunVelocity <run file 1> [<run file 2> <run file 3> ...]");
        }
        for(int i = 0; i < runFiles.length; i++) {
            processRunFile(runFiles[i]);
        }
    }

    /**
     * Process a single run file.
     *
     * @param file Name of the run file to process.
     */
    private void processRunFile(String file) throws Exception {
        DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
        builderFactory.setValidating(true);
        DocumentBuilder builder = builderFactory.newDocumentBuilder();
        Document doc = builder.parse(file);

        // Locate velocity element
        NodeList nodeList = doc.getChildNodes();
        for (int i = 0; i < nodeList.getLength(); i++) {
            if (nodeList.item(i).getNodeType() == Node.ELEMENT_NODE
            && nodeList.item(i).getNodeName().equals("velocity")) {
                processVelocityElement((Element)nodeList.item(i));
            }
        }
    }

    /**
     * Process the velocity element and process the velocity
     * template to generate the output file.
     * @param e Element node of the velocity element.
     * @return none.
     */
    private void processVelocityElement(Element e) throws Exception {
        VelocityEngine ve = new VelocityEngine();
        Template template = null;
        VelocityContext context = null;
        Writer writer = null;

        NodeList nodeList = e.getChildNodes();
        for (int i = 0; i < nodeList.getLength(); i++) {
            if (nodeList.item(i).getNodeName().equals("template")) {
                template = getTemplateFromElement(ve, (Element)nodeList.item(i));
            }
            if (nodeList.item(i).getNodeName().equals("output")) {
                writer = getWriterFromElement((Element)nodeList.item(i));
            }
            if (nodeList.item(i).getNodeName().equals("context")) {
                context = getContextFromElement((Element)nodeList.item(i));
            }
        }

        // Merge
        template.merge(context, writer);

        writer.flush();
        writer.close();
    }

    /** 
     * Obtain a velocity template object based on the
     * configuration specified in the run file template
     * element.
     *
     * @param ve Reference to a velocity engine.
     * @param e Element node of the template.
     * @return A new velocity Template.
     */
    private Template getTemplateFromElement(VelocityEngine ve, Element e) throws Exception {
        Template t = new Template();

        if (e.hasAttributes()) {
            Properties p = new Properties();
            p.setProperty("file.resource.loader.path", e.getAttribute("root"));
            ve.init(p);
            t = ve.getTemplate(e.getAttribute("file"));
        }

        return t;
    }

    /**
     * Obtain a writer object based on the
     * configuration specified in the run file output
     * element.
     *
     * @param e Element node of the output element.
     * @return A new writer pointing to an output file.
     */
    private Writer getWriterFromElement(Element e) throws Exception {
        Writer w = null;

        if (e.hasAttributes()) {
            File f = new File(e.getAttribute("root"), e.getAttribute("file"));
            w = new FileWriter(f);
        }

        return w;
    }

    /**
     * Obtain a velocity context object based on the
     * data specified in the run file context
     * element.
     *
     * @param e Element node of the context element.
     * @return A new velocity context.
     */
    private VelocityContext getContextFromElement(Element e) throws Exception {
        VelocityContext vc = new VelocityContext();

        // read all values
        NodeList nodeList = e.getChildNodes();
        for (int i = 0; i < nodeList.getLength(); i++) {
            if (nodeList.item(i).getNodeName().equals("property")) {
                Element value = (Element)nodeList.item(i);
                vc.put(value.getAttribute("name"), value.getAttribute("value"));
            }
        }

        // read all lists
        nodeList = e.getElementsByTagName("list");
        for (int i = 0; i < nodeList.getLength(); i++) {
            addListToContext(vc, (Element)nodeList.item(i));
        }

        return vc;
    }

    /**
     * Reads a single list element, constructs
     * an ArrayList and adds it to the context.
     *
     * @param vc Reference to a velocity context.
     * @param e Element node of the list.
     */
    private void addListToContext(VelocityContext vc, Element e) {
        ArrayList arrayList = new ArrayList();

        // read all maps and add to list
        NodeList nodeList = e.getElementsByTagName("object");
        for (int i = 0; i < nodeList.getLength(); i++) {
            arrayList.add(getMapFromElement((Element)nodeList.item(i)));
        }
        vc.put(e.getAttribute("name"), arrayList);
    }

    /**
     * Creates a HashMap given an object element.
     *
     * @param e Element node of the object element.
     * @return HasMap of the object element.
     */
    private HashMap getMapFromElement(Element e) {
        HashMap hashMap = new HashMap();

        // read all values and add to HashMap
        NodeList nodeList = e.getElementsByTagName("property");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element value = (Element)nodeList.item(i);
            hashMap.put(value.getAttribute("name"), value.getAttribute("value"));
        }

        return hashMap;
    }
}
```
