#!/usr/bin/env python
import sys
write = sys.stdout.write
for i in range(40, 49):
    for j in range(30, 39):
        for k in range(0, 10):
            write("\33[%d;%d;%dm%d;%d;%d\33[m " % (k, j, i, k, j, i))
        write("\n")
    write("\n")
