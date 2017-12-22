## writen by kubota

#arg setting
set flow_ctrl [lindex $argv 0]
set prj_name [lindex $argv 1]
set prj_rev $prj_name

## argv[0] ###################
#p: create projct only, x : map only, :  all : all 

#check arg
if { $flow_ctrl != "p" && $flow_ctrl != "x"  &&  $flow_ctrl != "all" } {
  puts "compile_prj.tcl : arg error"
  puts "arg is \"p\" or \"x\" or \"all\""
  exit
}

set setting_dir "../settings"


load_package flow

#create new project
#project_new -revision $prj_rev $prj_name -overwrite
if [catch {project_open -revision $prj_rev $prj_name}] {

  project_new -revision $prj_rev $prj_name -overwrite 
  puts "****** open new projcet ! ******************"
  
} else {
  puts "******* open exits project ! ***************"
  
}

source "prj_file.tcl"
source "syn_option.tcl"
source "${setting_dir}/device.tcl"

#SDC File Set
set_global_assignment -name SDC_FILE "${setting_dir}/${prj_name}.sdc"

source "${setting_dir}/pin_assign.tcl"
source "${setting_dir}/assignment.tcl"
#source "${setting_dir}/pin_assign_ddr.tcl"
#source "${setting_dir}/partition.tcl"

puts "******* signal tap ***************"
##signal tap
#set_global_assignment -name ENABLE_SIGNALTAP ON
#set_global_assignment -name USE_SIGNALTAP_FILE ../../signal_tap/stp1.stp
#set_global_assignment -name SIGNALTAP_FILE ../../signal_tap/stp1.stp


export_assignments

#qexec "quartus_stp ${prj_name} --stp_file ../../signal_tap/stp1.stp --enable"



if { $flow_ctrl == "x" } {

  puts "**** map start **********"
  qexec "quartus_map $prj_name"

# i option don't use
} elseif { $flow_ctrl == "i" } {

  puts "**** fitter start **********"
  qexec "quartus_fit $prj_name"

  puts "**** asm start **********"
  qexec "quartus_asm $prj_name"

  puts "*** timing analize start ********"
  qexec "quartus_sta $prj_name"


} elseif { $flow_ctrl == "all" } {
  execute_flow -compile
}


project_close

puts "*** finish compile_prj.tcl ********"


