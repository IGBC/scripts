#!/bin/sh
export LC_ALL=C
echo $(
	uptime | grep days | sed 's/.*up \([0-9]*\) day.*/\1\/10+/'
	grep '^cpu MHz' /proc/cpuinfo | awk '{print $4"/30 +";}'
	free | awk '{if ($0 ~ /^Mem/) {print $3"/1024/3+"} }'
	df -l -P -k -x nfs -x smbfs 2>/dev/null | grep -v '(1k|1024)-blocks' | awk '{if ($1 ~ "/dev/(cciss|scsi|sd)") {s+=$2} s+=$2;} END {print s/1024/50"/15+70";}'
	DISPLAY=${DISPLAY:-:0} xrandr 2>/dev/null | sed s:,::g | awk '
		BEGIN { s = "+ (0"; mult=0 }
		{
		if ($0 ~ /^Screen/) {
			mult += 2
			# 1      2  3       4   5 6   7       8    9 10   11      12   13 14
			# Screen 0: minimum 320 x 175 current 2560 x 1600 maximum 2560 x 1600
			s = s " + (("$8" / (640 / 2)) + ("$10" / (480 / 2)))"
			s = s " + (("$12" / 640) + ("$14" / 480))"
		}
		}
		END {
			s = s ") "
			while (mult > 0) {
				print s
				mult -= 1
			}
		}'
) | bc | sed 's/\(.$\)/.\1cm/'
