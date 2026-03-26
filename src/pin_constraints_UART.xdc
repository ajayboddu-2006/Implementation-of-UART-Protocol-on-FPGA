## ================= CLOCK =================
## ZedBoard 100 MHz oscillator
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]


## ================= RESET (Push Button BTNC) =================
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PULLTYPE PULLUP [get_ports rst]


## ================= WRITE ENABLE (Push Button BTNU) =================


## ================= 8-BIT DATA INPUT (Slide Switches SW0-SW7) =================



## ================= OPTIONAL: LED DISPLAY (LD0-LD7) =================
## Connect data_out to LEDs for debugging


set_property IOSTANDARD LVCMOS33 [get_ports {data_out[*]}]

set_property PACKAGE_PIN E3 [get_ports clk]
set_property PACKAGE_PIN J15 [get_ports rst]

set_property PACKAGE_PIN C4 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

set_property PACKAGE_PIN V10 [get_ports {data_in[7]}]
set_property PACKAGE_PIN U11 [get_ports {data_in[6]}]
set_property PACKAGE_PIN U12 [get_ports {data_in[5]}]
set_property PACKAGE_PIN H6 [get_ports {data_in[4]}]
set_property PACKAGE_PIN T13 [get_ports {data_in[3]}]
set_property PACKAGE_PIN R16 [get_ports {data_in[2]}]
set_property PACKAGE_PIN U8 [get_ports {data_in[1]}]
set_property PACKAGE_PIN T8 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V11 [get_ports {data_out[7]}]
set_property PACKAGE_PIN V12 [get_ports {data_out[6]}]
set_property PACKAGE_PIN V14 [get_ports {data_out[5]}]
set_property PACKAGE_PIN V15 [get_ports {data_out[4]}]
set_property PACKAGE_PIN T16 [get_ports {data_out[3]}]
set_property PACKAGE_PIN U14 [get_ports {data_out[2]}]
set_property PACKAGE_PIN T15 [get_ports {data_out[1]}]
set_property PACKAGE_PIN V16 [get_ports {data_out[0]}]
set_property PACKAGE_PIN D4 [get_ports tx]
set_property PACKAGE_PIN L16 [get_ports wr_enb]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports wr_enb]
