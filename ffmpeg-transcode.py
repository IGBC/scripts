#!/usr/bin/python3
import subprocess
import re
from os import path, system

def get_streams(filename):
    ret = subprocess.run(["ffmpeg", "-i", filename], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    output = ret.stderr.decode("UTF-8")
    streams = re.findall(r" *Stream #([0-9]+:[0-9]+)[\(|\[](\w+)[\)|\]]: (Audio|Video|Subtitle)", output)  
    mapping = {
        'video': [ {'stream': i[0], 'lang': i[1]} for i in list(filter(lambda x: x[2] == "Video", streams)) ],
        'audio': [ {'stream': i[0], 'lang': i[1]} for i in list(filter(lambda x: x[2] == "Audio", streams)) ],
        'subts': [ {'stream': i[0], 'lang': i[1]} for i in list(filter(lambda x: x[2] == "Subtitle", streams)) ]
        }
    return mapping

def __mapper(in_put, prefered_lang, other_langs, fallback):
    new_list = list(in_put)    
    mapping = []    
    prefered = False
    for i in new_list:
        if i['lang'] == prefered_lang:
            mapping.append('-map')
            mapping.append(i['stream'])
            new_list.remove(i)
            prefered = True
    if not prefered:
        if fallback is not None:
            mapping.append('-map')
            mapping.append(new_list[fallback]['stream'])
            new_list.remove(i)
    for i in new_list:
        if i['lang'] in other_langs:
            mapping.append('-map')
            mapping.append(i['stream'])
    return mapping


def map_streams(stream_map, prefered_lang='eng', other_langs=[], audio_fallback=0, subs_fallback=None):
    mapping = []
    for v in stream_map['video']:
        mapping.append('-map')
        mapping.append(v['stream'])
    for a in __mapper(stream_map['audio'], prefered_lang, other_langs, audio_fallback):
        mapping.append(a)    
    for s in __mapper(stream_map['subts'], prefered_lang, other_langs,  subs_fallback):   
        mapping.append(s)
    return mapping
    
    
def run():
    index_file = open ('index.txt', 'r+')
    index = index_file.readlines();    
    for i in index:      
        i_dir = path.dirname(i).rstrip()
        i_base = path.splitext(path.basename(i))[0].rstrip()
        i_ext = path.splitext(i)[1].rstrip()
        
        f_in = path.realpath(i_dir + "/" + i_base + i_ext)
        d_out = path.realpath("out/" + i_dir)
        f_out = d_out + "/" + i_base + ".mkv"
        
        cmd_base = ['ffmpeg','-nostdin','-i',f_in,]
        format_opts = ['-c:v','libx265','-crf','23','-strict','-2','-c:a','dca','-scodec','copy']
        mapping_opts = map_streams(get_streams(f_in), audio_fallback=1)
        output_file = [f_out]   
        cmd = cmd_base + format_opts + mapping_opts + output_file
        print('%s --⚙️ -> %s' % (f_in, f_out))
        system('mkdir -p "%s"' % d_out)    
        ret = subprocess.run(cmd, stderr=subprocess.PIPE)
        if ret.returncode != 0:
            print (ret.stderr.decode("UTF-8"))
            print ("    [ERROR]: ffmpeg returned error: %s" % ret.returncode)
            exit(1)

if __name__=='__main__':
    run()
