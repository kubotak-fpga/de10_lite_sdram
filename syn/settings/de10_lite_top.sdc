### de10_lite ###############
derive_clock_uncertainty
derive_pll_clocks -create_base_clocks


create_clock -name CLK1_50M -period 10.000 [get_ports {MAX10_CLK1_50}]
create_clock -name CLK2_50M -period 10.000 [get_ports {MAX10_CLK2_50}]

