#!/usr/bin/python
# -*- coding: utf-8 -*-

## msim_setup.tclからコンパイルするファイルを抜き出して ####
##  リスト(qsys_compile_list.sh)を生成する          #####
## Qsysを新たに生成した時に実行すること ####################


import re
import os

search_str = 'alias com'

qsys_sim_dir = '../../../hdl/qsys/sdram_qsys/sdram_qsys/simulation'
msimsetup_file = qsys_sim_dir + '/mentor/msim_setup.tcl'
w_fname = "qsys_compile_list.sh"

f = open(msimsetup_file, 'r')

f_list = []

flg = False

for line in f:
    line = line.rstrip('\n')
    #print(line)

    if re.match(search_str, line):
       flg = True
       continue

    if flg and re.match('}', line):
        break
        
    if flg:
        #print(line)
        f_list.append(line)


#for d in f_list:
#    print(d)

final_list = []

for line in f_list:
    temp1 = re.sub('-work\s+.+', "", line)
    temp2 = re.sub('-L\s+.+', "", temp1)
    temp3 = re.sub('eval\s*', "", temp2)
    
    ### {"+incdir+$QSYS_SIMDIR/submodules/"} ---> +incdir+$QSYS_SIMDIR/submodules/
    temp4 = re.sub('{"|"}', "", temp3)  

    #print(temp2)
    final_list.append(temp4)

#for d in final_list:
#    print(d)

## write file ####
f = open(w_fname, 'w')

## write header
f.write(r'#!/bin/bash')
f.write('\n')
#f.write(r'QSYS_SIMDIR="../../../hdl/qsys/ddr_qsys/ddr_qsys/simulation"')
f.write(r'QSYS_SIMDIR="{0}"'.format(qsys_sim_dir))

f.write('\n')
f.write(r'USER_DEFINED_COMPILE_OPTIONS="-quiet"')
f.write('\n')
f.write(r'USER_DEFINED_VERILOG_COMPILE_OPTIONS=""')

f.write('\n')

for line in final_list:
    f.write('%s\n' % line)


f.close()

## change file permission
cmd = 'chmod +x %s' % w_fname
os.system(cmd)

## change module name (bug fix)
#cmd = './modify_module_name.py'
os.system(cmd)

