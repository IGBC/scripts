#!/bin/bash
set -x
filename="${1%.*}"
ext="${1##*.}"
src="$(realpath "$filename")"
file="$(basename "$filename")"

folder="latexc"

mkdir $folder
folder_success=$?
cp "$src"."$ext" $(pwd)/$folder/"$file".tex 
cd latexc

xelatex "$file.tex" -interaction=nonstopmode  &&\
cp "$file.pdf" "$src.pdf" &&\
echo "Wrote output file to "$src".pdf"

cd .. 
rm $folder -R 
cd ..

