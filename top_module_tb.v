`timescale 1ns/1ns
module top_module_tb();
reg start;
reg clk;
reg rst;
wire CE_n;
wire OE_n;
wire WE_n;
wire UB_n;
wire LB_n;
wire [19:0] addr;
//inout [15:0] IO;
reg [15:0] data_in [13504:0];
wire [15:0] data_out;
//wire [6:0]seven1;
//wire [6:0]seven2;
//wire [6:0]seven3;
//wire [6:0]seven4;
//wire [6:0]seven5;
//wire [6:0]seven6;
//wire [6:0]seven7;
//wire [6:0]seven8;

integer fp_r, fp_w, cnt, i;

wire [14:0] addr_a_5 [4:0], addr_b_5 [4:0];
wire [2:0] stage;
wire sorted_rdy;
wire w_en_a, w_en_b;
wire if_last_angle;
wire best_angle_rdy;
wire [13:0] xc, yc;
wire [12:0] rE;
wire [7:0] tau;
wire [3:0] buffer, buffer_choose;
wire [11:0] theta, theta_min, theta_max;
wire [11:0] phi, phi_min, phi_max;
wire [11:0] alpha, alpha_min, alpha_max;
wire [11:0] theta_buffer [9:0], candidate_theta_buffer [9:0];
wire [11:0] phi_buffer [9:0], candidate_phi_buffer [9:0];
wire [7:0] score_buffer [9:0];
wire [20:0] score, score_tem, score_in;
wire score_rdy;
//wire [3:0] score_rest;
wire [3:0] index;
wire compare_rdy;
wire [15:0] total_cnt;
wire if_last_buffer, if_last_theta, if_last_phi, if_last_alpha, if_last_alpha_p1, if_last_angle_buffer, last_angle_compared_d;
wire [8:0] score_alpha_cnt;
wire [41:0] score_mul;


assign score_alpha_cnt = top_module_tb.tm.st.score_alpha_cnt;
genvar j;
generate
for(j=0;j<5;j=j+1)
begin:ad
	assign addr_a_5[j] = top_module_tb.tm.addr_a_5[j];
	assign addr_b_5[j] = top_module_tb.tm.addr_b_5[j];
end
for(j=0;j<10;j=j+1)
begin:cb
	assign theta_buffer[j] = top_module_tb.tm.st.angle_buffer[24*j+23-:12];
	assign phi_buffer[j] = top_module_tb.tm.st.angle_buffer[24*j+11-:12];
	assign candidate_theta_buffer[j] = top_module_tb.tm.st.candidate_angle_buffer[24*j+23-:12];
	assign candidate_phi_buffer[j] = top_module_tb.tm.st.candidate_angle_buffer[24*j+11-:12];
	assign score_buffer[j] = top_module_tb.tm.st.score_buffer[8*j+7-:8];
end
endgenerate

assign last_angle_compared_d = top_module_tb.tm.st.last_angle_compared_d;

assign stage = top_module_tb.tm.cu.ss.stage;
assign sorted_rdy = top_module_tb.tm.cu.sorted_rdy;
assign if_last_angle = top_module_tb.tm.if_last_angle;
assign best_angle_rdy = top_module_tb.tm.best_angle_rdy;
assign xc = top_module_tb.tm.xc;
assign yc = top_module_tb.tm.yc;
assign rE = top_module_tb.tm.rE;
assign tau = top_module_tb.tm.tau;
assign w_en_a = top_module_tb.tm.w_en_a;
assign w_en_b = top_module_tb.tm.w_en_b;
assign theta = top_module_tb.tm.theta;
assign phi = top_module_tb.tm.phi;
assign alpha = top_module_tb.tm.alpha;
assign buffer = top_module_tb.tm.cu.ss.buffer;
assign theta_max = top_module_tb.tm.cu.ss.theta_max;
assign phi_max = top_module_tb.tm.cu.ss.phi_max;
assign alpha_max = top_module_tb.tm.cu.ss.alpha_max;
assign theta_min = top_module_tb.tm.cu.ss.theta_min;
assign phi_min = top_module_tb.tm.cu.ss.phi_min;
assign alpha_min = top_module_tb.tm.cu.ss.alpha_min;
assign score = top_module_tb.tm.score;
assign score_mul = top_module_tb.tm.st.score_mul;
assign score_tem = top_module_tb.tm.st.score_tem;
assign score_in = top_module_tb.tm.st.score_in;
assign score_rdy = top_module_tb.tm.st.score_rdy;
//assign score_rest = top_module_tb.tm.score_rest;
assign index = top_module_tb.tm.st.index;
assign compare_rdy = top_module_tb.tm.st.compare_rdy;
assign if_last_buffer = top_module_tb.tm.cu.ss.if_last_buffer;
assign if_last_theta = top_module_tb.tm.cu.ss.if_last_theta;
assign if_last_phi = top_module_tb.tm.cu.ss.if_last_phi;
assign if_last_alpha = top_module_tb.tm.cu.ss.if_last_alpha;
assign if_last_alpha_p1 = top_module_tb.tm.cu.ss.if_last_alpha_p1;
assign if_last_angle_buffer = top_module_tb.tm.cu.ss.if_last_angle_buffer;

assign buffer_choose = top_module_tb.tm.cu.ss.buffer_choose;


top_module tm(.start(start), 
				  .clk(clk),
				  .rst(rst),
				  .CE_n(CE_n),
				  .OE_n(OE_n),
				  .WE_n(WE_n),
				  .UB_n(UB_n),
				  .LB_n(LB_n),
				  .addr(addr),
				  //.IO,
				  .IO(data_in[addr]),    //use to testbench
				  .data_out(data_out), 		   //use to testbench
				  .seven1(),
				  .seven2(),
				  .seven3(),
				  .seven4(),
				  .seven5(),
				  .seven6(),
				  .seven7(),
				  .seven8());	



//rI <= 13'd712; //44.5744

always#10 clk = ~clk;
initial
begin
	clk <= 1'b1;
	rst <= 1'b1;
	start <= 1'b1;
	#20
	start <= 1'b0;
	#20
	start <= 1'b1;
	//fp_w = $fopen("D:/eyetrack_troy/cvproject/cvproject/alpha_circle.txt", "w");
	fp_r=$fopen("D:/eyetrack_troy/cvproject/cvproject/sram029.txt","r");  //D:/FPGA_Troy/maching/   D:/eyetrack_troy/cvproject/cvproject/sram509.txt
	for(i=0;i<13504;i=i+1)
	begin
		cnt = $fscanf(fp_r, "%d", data_in[i][7:0]);
		cnt = $fscanf(fp_r, "%d", data_in[i][15:8]);
	end
	$fclose(fp_r);
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	
	#100010;
	start <= 1'b0;
	#20
	start <= 1'b1;
	//#270500 // 270220 + 280
	////#1344700
	//for(i=0;i<18;i=i+1)
	//begin
	//	#20
	//	$fwrite(fp_w, "%d %d %d %d %d %d %d %d %d\n",addr_a_5[3], addr_a_5[2], addr_a_5[1], addr_a_5[0], addr_b_5[3], addr_b_5[2], addr_b_5[1], addr_b_5[0], addr_a_5[4]);
	//end
	//$fclose(fp_w);
	#4000000
	$stop;
end	

endmodule