---
layout: default
title: Triangulated irregular network or TIN
tags: tin
---

Triangulated irregular network or TIN is used to represent a surface digitally, using non-overlapping triangles, where each node has x, y and z information. For the surface of the Earth, it is common to have the original data in the form of a digital elevation model or DEM, composed of 2D points and their elevation information. This information requires more bandwidth to transmit and store, especially if the terrains are relatively smooth. Converting this information to TIN can reduce storage space.

A TIN can easily be created from scratch in [SketchUp](http://www.sketchup.com/) or obtained by importing a DEM. Enable the [Sandbox tools](http://help.sketchup.com/en/article/116690) in SketchUp and create a surface from scratch. The TIN surface can be exported to DXF using the [SKP to DXF plugin](http://www.guitar-list.com/download-software/convert-sketchup-skp-files-dxf-or-stl) for SketchUp. Once installed, select the surface and use the plugin to export it as DXF.

If you have digital elevation data (x, y, altitude) then you can easily obtain a TIN by using the 2D triangulation algorithm from Delaunay. Open source [implementations](http://paulbourke.net/papers/triangulate/) are available for several languages. The C# implementation from [Ceometric](http://www.ceometric.com/downloads.html) has been used by this author. They also sell a much more efficient version at their site.
