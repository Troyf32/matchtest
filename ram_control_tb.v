`timescale 1ns/1ns
module ram_control_tb();
parameter width = 14;
reg start;							
reg clk;
reg rst;
reg [19:0] addr;

reg [width-1:0] new_xi0;
reg [width-1:0] new_yi0;
reg [width-1:0] new_xo0;
reg [width-1:0] new_yo0;
reg [width-1:0] new_xi1;
reg [width-1:0] new_yi1;
reg [width-1:0] new_xo1;
reg [width-1:0] new_yo1;
reg [width-1:0] new_xi2;
reg [width-1:0] new_yi2;
reg [width-1:0] new_xo2;
reg [width-1:0] new_yo2;
reg [width-1:0] new_xi3;
reg [width-1:0] new_yi3;
reg [width-1:0] new_xo3;
reg [width-1:0] new_yo3;
reg [width-1:0] xb_o, yb_o;
wire [14:0] addr_a_5 [4:0], addr_b_5 [4:0];
wire [14:0] addr_a_w, addr_b_w;
wire w_en_a_5;
wire w_en_b_5;
wire data_input_rdy, roi_input_rdy;
integer fp_r, fp_w, cnt, i;

assign addr_a_w = ram_control_tb.rc5.addr_a_w;
assign addr_b_w = ram_control_tb.rc5.addr_b_w;
assign roi_input_rdy = ram_control_tb.rc5.roi_input_rdy;

always#10 clk = ~clk;
initial
begin
	fp_r = $fopen("D:/eyetrack_troy/cvproject/cvproject/maching_score_point.txt", "r");
	fp_w = $fopen("D:/eyetrack_troy/cvproject/cvproject/ram_control_point.txt", "w");
	clk <= 1'b1;
	rst <= 1'b1;
	addr <= 20'd0;
	start <= 1'b0;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	start <= 1'b1;
	for(i=0;i<13504;i=i+1)
	begin
		#20
		addr <= addr + 1'b1;
	end
	for(i=0;i<18;i=i+1)
	begin	
		cnt = $fscanf(fp_r, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",new_xi0, new_yi0, new_xi1, new_yi1, new_xi2, new_yi2, new_xi3, new_yi3, new_xo0, new_yo0, new_xo1, new_yo1, new_xo2, new_yo2, new_xo3, new_yo3, xb_o, yb_o);
		#20
		$fwrite(fp_w, "%d %d %d %d %d %d %d %d %d\n",addr_a_5[3], addr_a_5[2], addr_a_5[1], addr_a_5[0], addr_b_5[3], addr_b_5[2], addr_b_5[1], addr_b_5[0], addr_a_5[4]);
	end
	$fclose(fp_r);
	$fclose(fp_w);
end


ram_control_5ram rc5(.start(start),
							.clk(clk),
							.rst(rst),
							.addr(addr),
							.new_xi({new_xi3, new_xi2, new_xi1, new_xi0}),
							.new_yi({new_yi3, new_yi2, new_yi1, new_yi0}),
							.new_xo({new_xo3, new_xo2, new_xo1, new_xo0}),
							.new_yo({new_yo3, new_yo2, new_yo1, new_yo0}),
							.xb_o(xb_o),
							.yb_o(yb_o),
							.addr_a_5({addr_a_5[4], addr_a_5[3], addr_a_5[2], addr_a_5[1], addr_a_5[0]}),
							.addr_b_5({addr_b_5[4], addr_b_5[3], addr_b_5[2], addr_b_5[1], addr_b_5[0]}),
							.w_en_a_5(w_en_a_5),
							.w_en_b_5(w_en_b_5));





endmodule