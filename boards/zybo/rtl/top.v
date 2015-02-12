`default_nettype none
`include "./setup.v"

module top (
	// CLOCK
	input  wire       clk_125,           // 125MHz system clock signal
	// dipswITCH
	input  wire [3:0] btn,
	input  wire [3:0] dipsw,             // switches
	output wire [3:0] led,
//	// TMDS
//	input  wire       hdmi_clk_p,
//	input  wire       hdmi_clk_n,
//	input  wire [2:0] hdmi_d_p,
//	input  wire [2:0] hdmi_d_n,
	output wire       hdmi_out_en,       // HDMI direction
	output wire       hdmi_hpd,          // Hot Plug Detect
	input  wire       hdmi_scl,          // DDC clock
	inout  wire       hdmi_sda           // DDC data
);

i2c_edid # (
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/DELL3007WFP.hex")
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/HP2159.hex")
	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/BENQ_E2200HD.hex")
) i2c_edid_inst_0 (
`ifdef DEBUG
	.switch(dipsw),
	.led(led),
`endif
	.clk(clk_125),
	.rst(btn[0]),
	.scl(hdmi_scl),
	.sda(hdmi_sda)
);

`ifndef DEBUG
assign led = dipsw;
`endif
assign hdmi_out_en = 1'b0;	// HDMI Direction = input
assign hdmi_hpd    = 1'b1;	// Hot Plug Detect = High

endmodule // top
`default_nettype wire
