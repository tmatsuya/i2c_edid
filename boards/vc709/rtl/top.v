`default_nettype none
`include "./setup.v"

module top (
        // 200MHz reference clock input
        input wire clk_ref_p,
        input wire clk_ref_n,
	// dipswITCH
	input  wire button_c,
//	// TMDS
	input  wire       hdmi_scl,          // DDC clock
	inout  wire       hdmi_sda           // DDC data
);

// Clock and Reset
wire clk_ref_200, clk_ref_200_i;
wire sys_rst;

reg [7:0] cold_counter = 8'h0;
reg cold_reset = 1'b0;

always @(posedge clk_ref_200) begin
        if (cold_counter != 8'hff) begin
                cold_reset <= 1'b1;
                cold_counter <= cold_counter + 8'd1;
        end else
                cold_reset <= 1'b0;
end

assign sys_rst = cold_reset | button_c;

IBUFGDS # (
        .DIFF_TERM    ("TRUE"),
        .IBUF_LOW_PWR ("FALSE")
) diff_clk_200 (
        .I    (clk_ref_p  ),
        .IB   (clk_ref_n  ),
        .O    (clk_ref_200_i )
);

BUFG u_bufg_clk_ref (
        .O (clk_ref_200),
        .I (clk_ref_200_i)
);


i2c_edid # (
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/DELL3007WFP.hex")
//	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/HP2159.hex")
	.HEX_FILE("/home/tmatsuya/i2c_edid/software/edid/BENQ_E2200HD.hex")
) i2c_edid_inst_0 (
	.clk(clk_ref_200),
	.rst(sys_rst),
	.scl(hdmi_scl),
	.sda(hdmi_sda)
);


endmodule // top
`default_nettype wire
