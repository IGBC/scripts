#!/usr/bin/env python3
import socket
import multiprocessing
import random
from time import sleep
from PIL import Image
from sys import exit, argv

def runner(packet_list, target_ip, target_port):
    while True:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            sock.connect((target_ip, target_port))
            while True:
                for packet in packet_list:
                    # print('Sending: "%s"' % packet)
                    sock.sendall(packet)
        except KeyboardInterrupt:
            exit()
        except Exception as e:
            print(str(e) + ': ' + ' :Connection failed, trying again') 



def start_flood(image, target_ip, target_port, thread_count, MTU, xoff = 0, yoff = 0, w = None, h = None):
    if w == None:
        w = image.width
    
    if h == None:
        h = image.height
    
    cmdlist = []
    # Generate a command for each pixel we draw
    print("Generating Commands... ")
    #bars = ["000000"] # blackout
    #bars = ["f40000", "ff8601", "faf601", "018821", "4600ff", "830189"] #LGBT Flag
    #bars = ["fff434", "ffffff", "9c59cf", "2d2d2d"] # Non Binary Flag
    bars = ["5bcefa", "f5a9b8", "ffffff", "f5a9b8", "5bcefa"] # Trans Flag
    for x in range(xoff, xoff + w):
        dw = x - xoff
        for y in range(yoff, yoff + h):
            dh = y - yoff
            # Get colour data
            colour_data = image.getpixel((dw,dh));
            # TODO transform colour data
            colstr = "{:02x}{:02x}{:02x}".format(colour_data[0], colour_data[1], colour_data[2])
            cmdlist.append("PX %i %i %s\n" % (x, y, colstr))
    
    # Shuffle list for dithered effect
    print("Shuffling Commands... ")
    random.shuffle(cmdlist)
    
    # Begin MTU Packing
    print("Building Packets... ")
    packed_cmd = [""]
    for cmd in cmdlist:
        if len(packed_cmd[-1]) + len(cmd) > MTU:
            packed_cmd.append(cmd)
        else:
            packed_cmd[-1] += cmd
            
    #encode commands
    print("Encoding Packets... ")
    for i in range(0, len(packed_cmd)):
        packed_cmd[i] = packed_cmd[i].encode()

    thread_count = min(thread_count, len(packed_cmd));
    
    # Split list into chucks for each thread
    print("Splitting into %i Threads... " % thread_count)
    avg = len(packed_cmd) / float(thread_count)
    thread_cmd = []
    last = 0.0
    while last < len(packed_cmd):
        thread_cmd.append(packed_cmd[int(last):int(last + avg)])
        last += avg
        
    # Spawn threads    
    print("Spawning Threads... ")
    jobs = []
    for i in thread_cmd:
        p = multiprocessing.Process(target=runner,args=(i, target_ip, target_port))
        jobs.append(p)
        p.start()
    print("Done!")

im = Image.open(argv[1])
start_flood(im, '94.45.234.189', 1234, 20, 9000, 0, 0, 320, 480)

## 94.45.235.49
