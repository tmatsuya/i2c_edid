`timescale 1ns / 1ps

module tb_hdmioverip();

`define simulation
//
// GMII Clock 125MHz
//
reg sys_clk;
initial sys_clk = 1'b0;
always #4 sys_clk = ~sys_clk;

//
//TMDS clock 74.25MHz
//
reg tmds_clk;
initial tmds_clk = 1'b0;
always #6.74 tmds_clk = ~tmds_clk;


//
// Test Bench
//
reg sys_rst;
reg rx_dv;
reg [7:0]rxd;
wire [7:0]o_r,o_g,o_b;

  wire VGA_HSYNC_INT, VGA_VSYNC_INT;
  wire   [10:0] bgnd_hcount;
  wire          bgnd_hsync;
  wire          bgnd_hblnk;
  wire   [10:0] bgnd_vcount;
  wire          bgnd_vsync;
  wire          bgnd_vblnk;
  reg sws_clk_sync;
  /*reg [10:0] tc_hsblnk;
  reg [10:0] tc_hssync;
  reg [10:0] tc_hesync;
  reg [10:0] tc_heblnk;
  reg [10:0] tc_vsblnk;
  reg [10:0] tc_vssync;
  reg [10:0] tc_vesync;
  reg [10:0] tc_veblnk;
*/
reg hvsync_polarity;
always @ (posedge tmds_clk)
  begin
    sws_clk_sync <= 4'b1111;
    hvsync_polarity <= 1'b0;
  end

  parameter HPIXELS_HDTV720P = 11'd1280; //Horizontal Live Pixels
  parameter VLINES_HDTV720P  = 11'd720;  //Vertical Live ines
  parameter HSYNCPW_HDTV720P = 11'd40;  //HSYNC Pulse Width
  parameter VSYNCPW_HDTV720P = 11'd5;    //VSYNC Pulse Width
  parameter HFNPRCH_HDTV720P = 11'd110;   //Horizontal Front Portch hotoha72
  parameter VFNPRCH_HDTV720P = 11'd5;    //Vertical Front Portch
  parameter HBKPRCH_HDTV720P = 11'd220;  //Horizontal Front Portch
  parameter VBKPRCH_HDTV720P = 11'd20;   //Vertical Front Portch


 parameter [10:0]tc_hsblnk = HPIXELS_HDTV720P - 11'd1;
 parameter [10:0]tc_hssync = HPIXELS_HDTV720P - 11'd1 + HFNPRCH_HDTV720P;
 parameter [10:0]tc_hesync = HPIXELS_HDTV720P - 11'd1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P;
 parameter [10:0]tc_heblnk = HPIXELS_HDTV720P - 11'd1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P + HBKPRCH_HDTV720P;
 parameter [10:0]tc_vsblnk =  VLINES_HDTV720P - 11'd1;
 parameter [10:0]tc_vssync =  VLINES_HDTV720P - 11'd1 + VFNPRCH_HDTV720P;
 parameter [10:0]tc_vesync =  VLINES_HDTV720P - 11'd1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P;
 parameter [10:0]tc_veblnk =  VLINES_HDTV720P - 11'd1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P + VBKPRCH_HDTV720P;
  
 wire reset_timing;
 wire restart = reset | reset_timing | reset_sig;
 wire [11:0]i_hcnt = {1'b0,bgnd_hcount};
 wire [11:0]i_vcnt = {1'b0,bgnd_vcount};

 timing timing_inst (
 	.tc_hsblnk(tc_hsblnk), //input
 	.tc_hssync(tc_hssync), //input
 	.tc_hesync(tc_hesync), //input
 	.tc_heblnk(tc_heblnk), //input
 	.hcount(bgnd_hcount), //output
 	.hsync(VGA_HSYNC_INT), //output
 	.hblnk(bgnd_hblnk), //output
 	.tc_vsblnk(tc_vsblnk), //input
 	.tc_vssync(tc_vssync), //input
 	.tc_vesync(tc_vesync), //input
 	.tc_veblnk(tc_veblnk), //input
 	.vcount(bgnd_vcount), //output
 	.vsync(VGA_VSYNC_INT), //output
 	.vblnk(bgnd_vblnk), //output
 	.restart(restart),
 	.clk(tmds_clk));
 
//
// GMII recieve
//
 wire [47:0]fifo_din;
 wire fifo_wr_en;
 gmii2fifo24 gmii2fifo24(
        .clk125(sys_clk),
        .sys_rst(sys_rst),
        .rxd(rxd),
        .rx_dv(rx_dv),
        .datain(fifo_din),
        .recv_en(fifo_wr_en),
        .packet_en()
 );

//
// FIFO 48
//
 wire fifo_rst = VGA_VSYNC;
 wire full,empty,fifo_read;
 wire [47:0]fifo_dout;
 wire [11:0]x_out_pos = fifo_dout[35:24];
 wire [11:0]y_out_pos = fifo_dout[47:36];
 wire [11:0]x_in_pos = fifo_din[35:24];
 wire [11:0]y_in_pos = fifo_din[47:36];
 afifo48 asfifo(
        .Data(fifo_din),
        .WrClock(sys_clk),
        .RdClock(tmds_clk),
        .WrEn(fifo_wr_en),
        .RdEn(fifo_read),
        .Reset(sys_rst),
        .RPReset(),
        .Q(fifo_dout),
        .Empty(empty),
        .Full(full)
);

//
// Data Controller
//

datacontroller #(
    .empty_interval(21'd49500)
  ) dataproc (
    .i_clk_74M(tmds_clk),
    .i_clk_125M(sys_clk),
    .i_rst(sys_rst),
    .i_hcnt(i_hcnt),
    .i_vcnt(i_vcnt),
    .i_format(2'b00),
    .reset_timing(reset_timing),
    .fifo_read(fifo_read),
    .fifo_wr_en(fifo_wr_en),
    .data(fifo_dout),
    .empty(empty),
    .full(full),
    .o_r(o_r),
    .o_g(o_g),
    .o_b(o_b)
  );
/*
datacontroller apple_out(
	.i_clk_74M(tmds_clk), //74.25 MHZ pixel clock
	.i_clk_125M(sys_clk),
	.i_rst(sys_rst),
	.i_format(2'b00),
	.i_vcnt(i_vcnt), //vertical counter from video timing generator
	.i_hcnt(i_hcnt), //horizontal counter from video timing generator^M
	.rx_dv(rx_dv),
        .rxd(rxd),
	.reset_timing(reset_timing),
	.gtxclk(sys_clk),
	.LED(),
	.SW(),
        .o_r(o_r),
        .o_g(o_g),
	.o_b(o_b)
);*/

  /////////////////////////////////////////
  // V/H SYNC and DE generator
  /////////////////////////////////////////

  reg v_sync;
  reg v_sync_buf;
  reg front_porch_en;
  reg reset_sig;
  reg [12:0]empty_cnt;
  reg [15:0]front_porch_cnt;
  reg active_en;
  always@(posedge tmds_clk)
	if(sys_rst)begin
		v_sync 		<= 1'b0;
		v_sync_buf 	<= 1'b0;
		empty_cnt 	<= 13'd0;
		front_porch_en 	<= 1'b0;
		front_porch_cnt	<= 16'd0;
		active_en 	<=1'b0;
	end else begin
		v_sync_buf <= v_sync;
		
		if({v_sync,v_sync_buf} == 2'b01)
			front_porch_en <= 1'b1;
		if(front_porch_en)
			front_porch_cnt <= front_porch_cnt + 16'd1;
		if(front_porch_cnt == 16'd33000)begin
			front_porch_en <= 1'b0;
			active_en <= 1'b1;
			reset_sig <= 1'b1;
		end else
			reset_sig <= 1'b0;
			
		if(~v_sync && empty)
			empty_cnt <= empty_cnt + 13'd1;
		else
			empty_cnt <= 13'd0;
		
		if(bgnd_vcount == 12'd720 /*&& empty_cnt >= 13'd4950*/)begin
			v_sync <= 1'b1;
			active_en <= 1'b0;
			//empty_cnt <= 13'd0;
		end
		if(fifo_wr_en)
			v_sync <= 1'b0;
	end
	
	reg [11:0]h_counter;
	reg [11:0]v_counter;
	
   always@(posedge tmds_clk)
	if(sys_rst)begin
		h_counter <= 12'd0;
		v_counter <= 12'd0;
	end else begin
		if(active_en)begin
			if(h_counter == 12'd1649)begin
				h_counter <= 12'd0;
				v_counter <= v_counter + 12'd1;
			end else
				h_counter <= h_counter + 12'd1;
		end
	end
	
	wire h_blnk = (h_counter >= 1280);
	wire v_blnk = (v_counter >= 720);
	wire de_active = !h_blnk && !v_blnk;
	wire h_sync = (h_counter >= 1390 && h_counter < 1430);
	
  reg active_q;
  reg VGA_HSYNC, VGA_VSYNC;
  reg de;

	
always @ (posedge tmds_clk)
  begin
    //hsync <= VGA_HSYNC_INT ^ hvsync_polarity ;
    //vsync <= VGA_VSYNC_INT ^ hvsync_polarity ;
    VGA_HSYNC <= h_sync;
    VGA_VSYNC <= v_sync;

    active_q <= de_active;
    de <= active_q;
  end


//
// a clock
//
task waitclock;
begin
	@(posedge sys_clk);
	#1;
end
endtask

task waittmdsclock;
begin
	@(posedge tmds_clk);
	#1;
end
endtask
//
// Scinario
//

reg [8:0] rom [0:4148684];
reg [22:0]counter = 23'd0;
reg reset_semi;

always@(posedge sys_clk)begin
	{rx_dv, rxd} 	<= rom[counter];
	counter	<= counter + 23'd1;
end
/*
reg [23:0] tmds [0:1188000];
reg [20:0] tmds_count = 21'd0;
always@(posedge tmds_clk)begin
	{i_hcnt, i_vcnt} <= tmds[tmds_count];
	tmds_count <= tmds_count + 21'd1;
end
*/
integer i;

initial begin
	$dumpfile("./test.vcd");
	$dumpvars(0, tb_hdmioverip);
	//$readmemh("tmds.mem",tmds);
	sys_rst = 1'b1;
	reset_semi = 1'b1;
	waitclock;
	waitclock;
	
	sys_rst = 1'b0;
	reset_semi = 1'b0;
	
	i = 0;
	for(i=0;i<50000;i=i+1)
		waittmdsclock;
	
	counter = 0;
	
	$readmemh("request.mem", rom);
	
	#100000000;
	$finish;
end

endmodule
