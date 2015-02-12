#!/bin/bash
for FILE in *.edid
do
        basename=${FILE##*/}
        filename=${basename%.*}
        hex_file="${filename}.hex"
	od -w1 -v -t x1 -An ${FILE} | sed -e "s/ //g" > ${hex_file}
done
