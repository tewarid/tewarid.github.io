#!/bin/bash
for i in *.md
do
    v=`grep title: "$i"`
    v=${v:7}
    # convert to lower case
    v=`echo ${v} | awk '{print tolower($0)}'`
    # remove double quotes
    v=`echo ${v//[\"]/}`
    # replace invalid file name characters with dash
    v=`echo ${v//[ \/?\":]/-}`
    mv "${i}" "${i:0:10}-$v.md"
done
