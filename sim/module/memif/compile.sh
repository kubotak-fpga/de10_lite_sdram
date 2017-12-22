#!/bin/bash


#VLOG_OPT="-vmake"
VLOG_OPT=""

## check Argument ##############

if [ $# -eq 0 ]; then
    arg1="rebuild"
else
    arg1=$1
fi

if [ $arg1 != "rebuild" -a $arg1 != "clean" ]; then
    
    echo "Param Error"
    echo "Param must \"rebuild\" or \"clean\""
    exit
fi

#echo "\$arg1 = $arg1"

## "clean" Action #####
if [ $arg1 = "clean" ]; then
    if [ -e ./work ]; then
	echo "delete working directory"
	rm -rf work
    fi

    if [ -e transcript ]; then
	rm -rf transcript
    fi

    if [ -e vsim.wlf ]; then
	rm -rf vsim.wlf
    fi
    exit
fi


# create workig directory
if [ -e ./work ]; then
    echo "delete working directory"
    rm -rf work
fi 

if [ ! -e ./work ]; then
    echo "create working directory"
    vlib ./work
fi


## compile qsys sim file ########
./qsys_compile_list.sh


## SDRAM Modle #################
vlog +define+den512Mb +define+sg75 +define+x16 ./sdram_model/sdr.v



## source file compile ###########
vlog ${VLOG_OPT} ../../../hdl/source/memif/write/avm_write_control.v
vlog ${VLOG_OPT} ../../../hdl/source/memif/read/avm_read_control.v
vlog ${VLOG_OPT} ../../../hdl/source/memif/memif_top.v

## compile test_bench ############
vlog ./tb_top.v



##### Create Makefile ##################################
if [ -e ./Makefile ]; then
    rm Makefile
fi

echo "create Makefile"
vmake > Makefile

