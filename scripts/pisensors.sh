#!/bin/bash
if [ ! `whoami`=="root"]
then
	echo "Need to be root to do this"
	exit 1
fi
Coretemp="/opt/vc/bin/vcgencmd measure_temp"
one=`$Coretemp`
two=`$Coretemp`
three=`$Coretemp`
while [ 1 ]
do
	three=$two
	two=$one
	one=`$Coretemp`
	clear
	echo "t-10s   $three"
 	echo "t -5s   $two"
	echo "t -0s   $one"
	sleep 5
done
