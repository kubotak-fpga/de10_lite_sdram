#!/usr/bin/python
import sys
import os
import re

def find_all_file(directory):

    file_list = []

    for root, dirs, files in os.walk(directory):
        for file_ in files:
            full_path = os.path.join(root, file_)
            file_list.append(full_path)

    return file_list


## main ###############
## arg[1]:msim_setup.tcl path
## arg[2]:1:generate sim, 0:no sim 

argvs = sys.argv
argc = len(argvs)

if (argc != 3):
    print('*** Arg Error *******')
    print('Usage:argv[1] search_path')
    print('Usage:argv[2] create sim modele?')
    exit(1)


## create file list ###########
flist = find_all_file(argvs[1])

## create qsys_list from flist ##########

qsys_list = []
for f in flist:
    if re.match('.*\.qsys$', f):
        qsys_list.append(f)
        print('find {0}'.format(f))



## generate sim file, if argvs[2] == 1 #######
if argvs[2] == '1' : 
    for f in qsys_list:
        (no_ext, ext) = os.path.splitext(f)
        cmd = '$QSYS_ROOTDIR/qsys-generate %s --simulation=VERILOG --allow-mixed-language-simulation --output-directory=%s --family="MAX 10" --part=10M50DAF484C7G' % (f, no_ext)
        print("*** generate sim qsys_file: %s***" %f)
        os.system(cmd)


## generate qsys file #########
for f in qsys_list:
    (no_ext, ext) = os.path.splitext(f)
    cmd = '$QSYS_ROOTDIR/qsys-generate %s --synthesis=VERILOG --output-directory=%s --family="MAX 10" --part=10M50DAF484C7G' % (f, no_ext)
    print("*** generate qsys_file: %s***" %f)
    os.system(cmd)





