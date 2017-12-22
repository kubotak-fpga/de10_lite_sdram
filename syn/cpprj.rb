#!/usr/bin/ruby

file1 = File.open("../../prj_file.tcl","r");
buffer = file1.read();
buffer.gsub!("\"../","\"../../../");
file2 = File.open("prj_file.tcl","w");

file2.write(buffer);

file1.close();
file2.close();

