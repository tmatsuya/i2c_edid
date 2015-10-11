##Clock signal
create_clock -name mcb_clk_ref -period 5 [get_ports clk_ref_p]

# Bank: 38 - Byte 
set_property VCCAUX_IO DONTCARE [get_ports {clk_ref_p}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {clk_ref_p}]
set_property PACKAGE_PIN H19 [get_ports {clk_ref_p}]
#
# Bank: 38 - Byte 
set_property VCCAUX_IO DONTCARE [get_ports {clk_ref_n}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {clk_ref_n}]
set_property PACKAGE_PIN G18 [get_ports {clk_ref_n}]

#button
set_property PACKAGE_PIN AV39 [get_ports {button_c}]
set_property IOSTANDARD LVCMOS18 [get_ports {button_c}]

#tmds
set_property PACKAGE_PIN M41 [get_ports hdmi_scl]
set_property IOSTANDARD LVCMOS18 [get_ports hdmi_scl]

set_property PACKAGE_PIN L41 [get_ports hdmi_sda]
set_property IOSTANDARD LVCMOS18 [get_ports hdmi_sda]

