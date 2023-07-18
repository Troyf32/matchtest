`timescale 1ns/1ns
module boundary_tb();
parameter N = 21 ;
parameter M = 13 ;
reg clk;
reg rst;
reg [M-1:0] rE;			// 512  取小數點後4bit
reg [11:0] theta, phi, alpha;
reg [13:0] xc, yc;
reg [7:0] tau;
wire [M:0] xb, yb;

wire [9:0] c_al_value_line, c_al_value;

//wire [N-1:0] tau_reg;		// 取小數點後8bit
//wire [7:0] tau;				// 取小數點後8bit
//wire [N-1:0] rI_shift;

integer i, fp_w, fp_w1;


assign c_al_value = boundary_tb.bc.c_al_value;
assign c_al_value_line = boundary_tb.bc.c_al_value_line;

boundary_cal #(.N(N), .M(M))
				bc(.rE(rE), 
					.xc(xc), 
					.yc(yc), 
					.theta(theta), 
					.phi(phi), 
					.alpha(alpha), 
					.xb(xb), 
					.yb(yb), 
					.clk(clk),
					.rst(rst),
					.tau(tau));
				
always#10 clk = ~clk;
initial
begin
	clk <= 1'b1;
	rst <= 1'b1;
	#8
	rst <= 1'b0;
	#8
	rst <= 1'b1;
	//tau <= 8'd153;
	//rE <= 13'd1320;
	////rI <= 13'd728;
	//xc <= 14'd3255;//203.447
	//yc <= 14'd1389;//86.8368
	//theta <= 12'd0;
	//phi <= 12'd0;
	//alpha <= 12'd0;
	//clk <= 1'b0; 
	tau <= 8'd139;  // sqrt(1-tau2) = 0.8388
	rE <= 13'd1308;//81.7641
	//rI <= 13'd712; //44.5744
	xc <= 14'd3213-14'd1776;//200.831
	yc <= 14'd1580-14'd176;//98.8053
	//theta <= 12'd210;
	//phi <= 12'd1475;
	//theta <= 12'd210;
	//phi <= 12'd1475;
	theta <= 12'd190;
	phi <= 12'd320;
	alpha <= 12'd0;
	
	#8
	/////////////////////////////////////////7777777777777777777777777//////////////////////////
	
	/////////////////////////////////////////7777777777777777777777777//////////////////////////
	
	//rst = 1'b1 ;
	
	//fp_w1=$fopen("D:/FPGA_Troy/match/simulation/modelsim/maching_389.txt","w");
	fp_w=$fopen("D:/eyetrack_troy/cvproject/cvproject/maching_389.txt","w");  //D:/FPGA_Troy/maching/
	for(i=0;i<9;i=i+1)
	begin
		#20
		alpha = alpha+12'd200;
	end
	#10
	for(i=9;i<27;i=i+1)
	begin
		#10
		alpha = alpha+12'd200;
		#10//$fwrite(fp_w1,"%d\t",xb,"%d\n",yb);
		$fwrite(fp_w,"%d\t",xb,"%d\n",yb);
	end
	//$fclose(fp_w1);
	$fclose(fp_w);
end
endmodule
//	forever
//	begin
//	#100
//	if(res_rdy == 1'b1)
//		$stop;
//	end