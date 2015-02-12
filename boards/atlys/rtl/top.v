`default_nettype none
`include "./setup.v"

module top (
	// CLOCK
	input  wire       CLK_100MHZ,        // 100MHz system clock signal
	// SWITCH
	input  wire       BTN_RESET_N,
	input  wire [7:0] SW,                // switches
	output wire [7:0] LED,
//	// TMDS INPUT (J3)
//	input  wire [3:0] RX0_TMDS,
//	input  wire [3:0] RX0_TMDSB,
	input  wire       RX0_SCL,
	inout  wire       RX0_SDA
);

i2c_edid # (
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/DELL3007WFP.hex")
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/HP2159.hex")
	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/BENQ_E2200HD.hex")
) i2c_edid_inst_0 (
`ifdef DEBUG
	.switch(SW),
	.led(LED),
`endif
	.clk(CLK_100MHZ),
	.rst(~BTN_RESET_N),
	.scl(RX0_SCL),
	.sda(RX0_SDA)
);

`ifndef DEBUG
assign LED = SW;
`endif

endmodule // top
`default_nettype wire
