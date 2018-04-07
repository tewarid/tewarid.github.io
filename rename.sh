#!/bin/bash
for i in *.md; do v=`grep title: $i`; v=${v:7}; v=`echo ${v} | awk '{print tolower($0)}'`; v=`echo ${v//[ \/?\":]/-}`; mv ${i} ${i:0:10}-$v.md; done