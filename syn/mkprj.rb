#!/usr/bin/ruby

## Create pjr tcl script file

create_fname = "prj_file.tcl"

file = File.open("#{create_fname}","w");

#find VERILOG_FILE(*.v)
Dir::glob("../../hdl/source/**/*.v").each {|f|
  file.puts "set_global_assignment -name VERILOG_FILE \"#{f}\""
}

#find SYSTEM_VERILOG_FILE(*.sv)
#Dir::glob("../hdl/source/**/*.sv").each {|f|
#  file.puts "set_global_assignment -name SYSTEMVERILOG_FILE \"#{f}\""
#}

#find VHDL_FILE(*.vhd)
Dir::glob("../../hdl/source/**/*.vhd").each {|f|
  file.puts "set_global_assignment -name VHDL_FILE \"#{f}\""
}

#find QIP_FILE(*.qip)
Dir::glob("../../hdl/altera_ip/**/*.qip").each {|f|
  file.puts "set_global_assignment -name QIP_FILE \"#{f}\""
}



#find QSYS QIP_FILE(*.qip)
Dir::glob("../../hdl/qsys/**/*.qip").each {|f|
  file.puts "set_global_assignment -name QIP_FILE \"#{f}\""
}

Dir::glob("../../hdl/qsys/**/*.qsys").each {|f|
  file.puts "set_global_assignment -name QSYS_FILE \"#{f}\""
}


#find SIP_FILE(*.sip)
#Dir::glob("../../hdl/altera_ip/**/*.sip").each {|f|
#  file.puts "set_global_assignment -name SIP_FILE \"#{f}\""
#}

file.close





