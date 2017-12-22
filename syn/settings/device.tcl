## DE10-Lite Board ####

# Device ##################################################################

set_global_assignment -name FAMILY "MAX 10"
set_global_assignment -name DEVICE 10M50DAF484C7G
set_global_assignment -name TOP_LEVEL_ENTITY de10_lite_top
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 17.1.0
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 484
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
#set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
#set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
#set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top


# Bank VCCIO ##############################################################
#set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3A
#set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3B
#set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3C
#set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3D

