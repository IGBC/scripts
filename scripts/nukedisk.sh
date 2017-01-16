#!/bin/bash

#preliminary blocksize
bs=32M; #optimal for Sata HDDs

#parameter count check and argument fill
if [ "$#" -ne 1 ]; then
	if [ "$#" -ne 2 ]; then
		echo "Error: Invalid number of aguments"
		echo ""
    	echo "Usage: nukedisk /path/to/disk [blocksize]"
    	echo "Example: nukedisk /dev/sdb [1M]"
    	exit 1
    else
    	bs=$2;
    fi
fi

#check elevation
if [[ $EUID -ne 0 ]]; then
	echo "Error: This program needs to be run as root"
	exit 2
fi

#check output file exists
if [ -e "$1" ]; then
	echo "Writing to $1"
	#do the job
	echo "Starting pass 1 [0]"
	dd if=/dev/zero bs=$bs |pv -rb | dd of=$1 bs=$bs
	echo "Starting pass 2 [1]"	
	dd if=<(yes $'\xFF' | tr -d "\n") bs=$bs |pv -rb | dd of=$1 bs=$bs
	echo "Starting pass 3 [0]"	
	dd if=/dev/zero bs=$bs |pv -rb | dd of=$1 bs=$bs
	exit 0
else
	echo "Error: $1 does not exist"
	exit 3
fi
