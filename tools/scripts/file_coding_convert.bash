#!/bin/bash

file=$1

if [[ $(file -i $file) == *"charset=utf-8"* ]]; then
    echo "$file is already utf-8 encoded"
else
    echo "$file is not utf-8 encoded"
    # iconv -f $(file -bi $file | awk -F "=" '{print $2}') -t utf-8 $file > ${file}.utf8
    iconv -f GBK -t utf-8 "$file" > "$file.temp"
    mv "$file.temp" "$file"
fi
