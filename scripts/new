#!/bin/bash

#Program
dir=$(pwd)
filename=$(basename "$1")
extention="${filename##*.}"
#test file exists
if [ -f "$1" ]
then
	echo "Error: file $dir/$1 already exists"
	echo "This script will not overwrite the file"
	exit 1
fi
#make file
echo "Creating $dir/$1"

case "$extention" in 
	sh)
		echo "#!/bin/bash" > $1
		chmod u+x $1
		;;
	py)
		echo "#!/usr/bin/python" > $1
		chmod u+x $1
		;;
	rb)
		echo "#!/usr/bin/ruby" > $1
		chmod u+x $1
		;;
	c)
		echo "#include <stdio.h>" > $1
		echo "#include <stdlib.h>" >> $1
		echo "" >> $1
		echo "int main (int argc, char *argv[]) {" >> $1
		echo "    " >> $1
		echo "}" >> $1
		;;
	*)
		echo "Unknown Extention: $extention"
		exit 1
esac
echo "Setting Exectutable bit on $dir/$1"
subl $1
