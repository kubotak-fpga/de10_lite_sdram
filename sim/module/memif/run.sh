#!/bin/bash

QSYS_SIMDIR="../../../hdl/qsys/ddr_qsys/ddr_qsys/simulation"

#cp ${QSYS_SIMDIR}/submodules/*.hex ./



# vsim top_sim work.glbl \
vsim \
   -L work \
   -L altera_ver \
   -L lpm_ver \
   -L sgate_ver \
   -L altera_mf_ver \
   -L altera_lnsim_ver \
   -L fiftyfivenm_ver \
   -voptargs="+acc" \
   tb_top

















