`timescale 1ns/1ns
module Matching_point_cal_tb();
parameter width = 14;
reg clk;
reg rst;
reg [11:0] theta;
reg [11:0] phi;
reg [11:0] alpha;
reg [13:0] xc, yc;
reg [7:0] tau;
reg [12:0] rE;
wire [width-1:0] new_xi0;
wire [width-1:0] new_yi0;
wire [width-1:0] new_xo0;
wire [width-1:0] new_yo0;
wire [width-1:0] new_xi1;
wire [width-1:0] new_yi1;
wire [width-1:0] new_xo1;
wire [width-1:0] new_yo1;
wire [width-1:0] new_xi2;
wire [width-1:0] new_yi2;
wire [width-1:0] new_xo2;
wire [width-1:0] new_yo2;
wire [width-1:0] new_xi3;
wire [width-1:0] new_yi3;
wire [width-1:0] new_xo3;
wire [width-1:0] new_yo3;
wire [width-1:0] xb_o, yb_o;
wire [13:0] iris_center_x, iris_center_y;
wire [13:0] xb, yb;
integer fp_r, fp_w, cnt, i;

assign iris_center_x = Matching_point_cal_tb.mpc.ic.iris_center_x;
assign iris_center_y = Matching_point_cal_tb.mpc.ic.iris_center_y;
assign xb = Matching_point_cal_tb.mpc.bc.xb;
assign yb = Matching_point_cal_tb.mpc.bc.yb;

Matching_point_cal mpc(.clk(clk),
							  .rst(rst),
							  .theta(theta),
							  .phi(phi),
							  .alpha(alpha),
							  .xc(xc),
							  .yc(yc),
							  .tau(tau),
							  .rE(rE),
							  .new_xi({new_xi3, new_xi2, new_xi1, new_xi0}),
							  .new_yi({new_yi3, new_yi2, new_yi1, new_yi0}),
							  .new_xo({new_xo3, new_xo2, new_xo1, new_xo0}),
							  .new_yo({new_yo3, new_yo2, new_yo1, new_yo0}),
							  .xb_o(xb_o),
							  .yb_o(yb_o));
							  
always#10 clk = ~clk;
initial
begin
	clk <= 1'b1;
	tau <= 8'd139;  // sqrt(1-tau2) = 0.545158572
	rE <= 13'd1308;//81.7641
	//rI <= 13'd712; //44.5744
	xc <= 14'd3213;//200.831
	yc <= 14'd1580;//98.8053
	//theta <= 12'd210;
	//phi <= 12'd1475;
	//theta <= 12'd210;
	//phi <= 12'd1475;
	theta <= 12'd190;
	phi <= 12'd320;
	
	alpha <= 12'd0;
	//fp_w1=$fopen("D:/FPGA_Troy/match/simulation/modelsim/maching_389.txt","w");
	fp_w=$fopen("D:/eyetrack_troy/cvproject/cvproject/maching_score_point.txt","w");  //D:/FPGA_Troy/maching/maching_score_point.txt
	//#500
	for(i=0;i<15;i=i+1)
	begin
		#20
		alpha = alpha+12'd200;	
	end
	for(i=15;i<33;i=i+1)  // 14clk
	begin
		$fwrite(fp_w, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",new_xi0, new_yi0, new_xi1, new_yi1, new_xi2, new_yi2, new_xi3, new_yi3, new_xo0, new_yo0, new_xo1, new_yo1, new_xo2, new_yo2, new_xo3, new_yo3, xb_o, yb_o);
		#20	
		alpha = alpha+12'd200;
	end
	$fclose(fp_w);
end
							  
endmodule								  