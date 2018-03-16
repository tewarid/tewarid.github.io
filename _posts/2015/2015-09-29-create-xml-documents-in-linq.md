---
layout: default
title: Create XML documents in LINQ
tags: xml c# linq programming .net
comments: true
---

I've created XML documents using string concatenation, and DOM implementations, in the past. LINQ in .NET provides an [interesting mechanism](https://msdn.microsoft.com/en-us/library/bb387019.aspx) for document creation.

I'll use the following XML document obtained from IETF's [PIDF-LO spec](https://tools.ietf.org/html/rfc5491), as an example

```xml
<presence xmlns="urn:ietf:params:xml:ns:pidf" xmlns:dm="urn:ietf:params:xml:ns:pidf:data-model" xmlns:gp="urn:ietf:params:xml:ns:pidf:geopriv10" xmlns:gml="http://www.opengis.net/gml" xmlns:cl="urn:ietf:params:xml:ns:pidf:geopriv10:civicAddr" entity="pres:mike@seattle.example.com">
    <dm:device id="mikepc">
        <gp:geopriv>
            <gp:location-info>
                <gml:Point srsName="urn:ogc:def:crs:EPSG::4326">
                    <gml:pos>-43.5723 153.21760</gml:pos>
                </gml:Point>
                <cl:civicAddress>
                    <cl:FLR>2</cl:FLR>
                </cl:civicAddress>
            </gp:location-info>
            <gp:usage-rules/>
            <gp:method>Wiremap</gp:method>
        </gp:geopriv>
        <dm:deviceID>mac:8asd7d7d70cf</dm:deviceID>
        <dm:timestamp>2007-06-22T20:57:29Z</dm:timestamp>
    </dm:device>
</presence>
```

Note that the document uses multiple schemas. This is how LINQ's functional document creation can be used to recreate the above document using C#

```c#
XNamespace pidf = "urn:ietf:params:xml:ns:pidf";
XNamespace dm = "urn:ietf:params:xml:ns:pidf:data-model";
XNamespace gp = "urn:ietf:params:xml:ns:pidf:geopriv10";
XNamespace gml = "http://www.opengis.net/gml";
XNamespace cl = "urn:ietf:params:xml:ns:pidf:geopriv10:civicAddr";

XElement presence = new XElement(
    pidf + "presence",
    new XAttribute("xmlns", pidf.NamespaceName),
    new XAttribute(XNamespace.Xmlns + "dm", dm.NamespaceName),
    new XAttribute(XNamespace.Xmlns + "gp", gp.NamespaceName),
    new XAttribute(XNamespace.Xmlns + "gml", gml.NamespaceName),
    new XAttribute(XNamespace.Xmlns + "cl", cl.NamespaceName),
    new XAttribute("entity", "pres:mike@seattle.example.com"),
    new XElement(
        dm + "device",
        new XAttribute("id", "mikepc"),
        new XElement(
            gp + "geopriv",
            new XElement(
                gp + "location-info",
                new XElement(
                    gml + "Point",
                    new XAttribute("srsName", "urn:ogc:def:crs:EPSG::4326"),
                    new XElement(gml + "pos", "-43.5723 153.21760")
                ),
                new XElement(
                    cl + "civicAddress",
                    new XElement(cl + "FLR", 2)
                )
            ),
            new XElement(gp + "usage-rules", ""),
            new XElement(gp + "method", "Wiremap")
        ),
        new XElement(dm + "deviceID", "mac:8asd7d7d70cf"),
        new XElement(dm + "timestamp",  DateTime.UtcNow.ToString("yyyy-MM-ddThh:mm:ssZ"))
    )
);

XDocument presenceDocument = new XDocument(presence);
Console.WriteLine(presenceDocument.ToString());
```
