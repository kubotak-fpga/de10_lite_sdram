#!/bin/bash
# altera compile script
# 2017/12/ made by K.Kubota

# usage : sh local_build.sh <opts>
# <opt> -help or -h or --help

# altera quartus enviroment setting


####################################

time_start=`date +%s`


#show help
show_help()
{
    echo "usage : sh local_build.sh <opts>"
    echo "       p     : only create quartus new project"
    echo "       x     : synthesize only (create new projet)"
    echo "       clean : clean up quartus generated files"
    echo "       rebuild or no arg : create new project and compile all"

    return 0
}


#show help
if [ "$1" = "-help" -o "$1" = "-h" -o "$1" = "--h" -o "$1" = "--help" ]; then
    show_help
    exit 1
fi

#check argument
if [ $# -eq 1 ] ; then
    if [ ! \( "$1" = "x" -o "$1" = "p" -o "$1" = "clean" -o "$1" = "rebuild" \) ] ; then
        echo "argv error!"
        show_help
        exit 1
    fi
fi

# set project name
prj_name="de10_lite_top"

# clean up auto generated files ----------------------------
if [ "$1" = "clean" ] ; then
    rm -rf rev/ rev_bak/
    rm -f prj_file.tcl
    echo "**** clean up complete ********"
    echo
    exit 1
else

    if [ -d rev/ ] ; then
        if [ -d rev_bak/ ] ; then
            rm -rf rev_bak
        fi
        mv rev rev_bak
    fi
    


    #copy user_qsys_component, To qsys folder
    #cp -r ../hdl/qsys_lib/fx3_ctrl ../hdl/qsys/system_qsys


    # generate qsys_file from "**.qsys"  1:Create Sim, 0:No Sim
    if [ "$1" != "x" ] ; then
    ./gen_qsys_file.py "../hdl/qsys" 1
    fi
    
    mkdir rev
    cd rev

    ../mkprj.rb # generate prj_file.tcl
    cp ../compile_prj.tcl         ./ || { echo "Error! compile_prj.tcl file does not exist"; exit 1 ; }
    cp ../settings/syn_option.tcl ./ || { echo "Error!  syn_option.tcl file does not exist"; exit 1 ; }
    
    #set compile_arg
    if [ "$1" = "rebuild" -o "$1" = "" ] ; then
	compile_arg="all"
    else
	compile_arg="$1"
    fi

    quartus_sh --64bit -t compile_prj.tcl $compile_arg $prj_name | tee build.log

    if [ "$1" != "p" ] ; then

        if [ ! -f output_files/$prj_name.sof ] ; then
            echo -e "\e[31m"  #display red
            echo "**** Extract Error report ********************************"
            echo
            grep "Error" output_files/*.rpt
	    echo -e "\e[m"
        else

            # extract critical warning report
            echo -e "\e[31m" #display red
            echo "**** Extract Critical Warning report ************************************"
            echo
            grep "Critical Warning" output_files/*.rpt

	    echo -e "\e[m"
	    
        fi
    fi
fi

