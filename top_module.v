module top_module(start, 
						clk,
						rst,
						CE_n,
						OE_n,
						WE_n,
						UB_n,
						LB_n,
						addr,
						IO,			//use to testbench
						data_out,   //use to testbench
						seven1,
						seven2,
						seven3,
						seven4,
						seven5,
						seven6,
						seven7,
						seven8);	
parameter width = 14;					
input start;
input clk;
input rst;
//wire rst;
output CE_n;
output OE_n;
output WE_n;
output UB_n;
output LB_n;
output [19:0] addr;
//inout [15:0] IO;   	 //use to testbench
input [15:0] IO;	 		 //use to testbench
output [15:0] data_out;  //use to testbench
output [6:0]seven1;
output [6:0]seven2;
output [6:0]seven3;
output [6:0]seven4;
output [6:0]seven5;
output [6:0]seven6;
output [6:0]seven7;
output [6:0]seven8;


wire [11:0] theta;
wire [11:0] phi;
wire [11:0] alpha; 
wire [13:0] xc, yc;
wire [7:0] tau;
wire [12:0] rE;
wire [width*4-1:0] new_xi, new_yi, new_xo, new_yo;
wire [width-1:0] xb_o, yb_o;

wire w_en_a, w_en_b;
wire [15:0] sram_data_in;
wire [11:0] best_angle;
wire [7:0] data_out_a [4:0], data_out_b [4:0];
//wire [16:0] score;
wire [20:0] score;
//wire [3:0] score_rest;
wire score_rdy;
wire [8:0] score_alpha_num;
wire [3:0] compare_num;
wire if_last_angle;
wire [24*10-1:0] candidate_angle_buffer;
wire best_angle_rdy;
reg [23:0] best_angle_to_sram;
reg clk_s;
wire start_d;


//wire start_cal;
//assign start_cal = (addr>20'h34bf)?1'b1:1'b0;
assign sram_data_in = IO;
//assign IO 		 = (WE_n)?16'dz:{{4{1'b0}},best_angle};  		//use to testbench
assign data_out = (WE_n)?16'dz:{{4{1'b0}},best_angle}; 	//use to testbench
//assign clk_s = start?clk:1'b0;

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		clk_s <= 1'b0;
	end
	else
	begin
		clk_s <= ~clk_s;
	end
end

debounce_sw ds(.in(start),
					.out(start_d),
					.clk(clk),
					.rst(start));

control_unit cu(.start(start_d), 
				    .clk(clk_s),
				    .rst(start_d),
					 .addr(addr),
					 .candidate_angle_buffer(candidate_angle_buffer),
				    .theta(theta),
					 .phi(phi),
					 .alpha(alpha),
					 .score_alpha_num(score_alpha_num),
					 //.cal_point_rdy(cal_point_rdy), //use for stall 5 clk
					 .score_rdy(score_rdy),
					 .compare_num(compare_num),
					 .if_last_angle(if_last_angle),   ///////////// not defined yet////////////////
					 .best_angle_rdy(best_angle_rdy));
					 
sram_controllor sc(.start(start_d),
						 .clk(clk_s),
						 .rst(start_d),
						 .addr(addr),
						 .CE_n(CE_n),
						 .OE_n(OE_n),
						 .WE_n(WE_n),
						 .UB_n(UB_n),
						 .LB_n(LB_n),
						 .sram_data_in(sram_data_in),
						 .best_angle_rdy(best_angle_rdy),
						 .xc(xc),
						 .yc(yc),
						 .tau(tau),
						 .rE(rE),
						 .candidate_angle_buffer(candidate_angle_buffer[23:0]),
						 .best_angle(best_angle));	
				
Matching_point_cal Mpc(.clk(clk_s),
							  .rst(start_d),
						     .theta(theta),
						     .phi(phi),
						     .alpha(alpha),
						     .xc(xc),
						     .yc(yc),
						     .tau(tau),
						     .rE(rE),
						     .new_xi(new_xi),
						     .new_yi(new_yi),
						     .new_xo(new_xo),
						     .new_yo(new_yo),
						     .xb_o(xb_o),
						     .yb_o(yb_o));

////////////////////////////////////////////////*****ram for 1 clk*****/////////////////////////////////////////////////////////////////	

wire [14:0] addr_a_5 [4:0], addr_b_5 [4:0];
						  
ram_control_5ram rc5(.start(start_d),
							.clk(clk_s),
							.rst(start_d),
							.addr(addr),
							.new_xi(new_xi),
							.new_yi(new_yi),
							.new_xo(new_xo),
							.new_yo(new_yo),
							.xb_o(xb_o),
							.yb_o(yb_o),
							.addr_a_5({addr_a_5[4], addr_a_5[3], addr_a_5[2], addr_a_5[1], addr_a_5[0]}),
							.addr_b_5({addr_b_5[4], addr_b_5[3], addr_b_5[2], addr_b_5[1], addr_b_5[0]}),
							.w_en_a_5(w_en_a),
							.w_en_b_5(w_en_b));

genvar i;							
generate
for(i=0;i<5;i=i+1)
begin:ra5
	ram_roi r5(.address_a(addr_a_5[i]),
				  .address_b(addr_b_5[i]),
				  .clock(clk_s),
				  .data_a(IO[7:0]),
				  .data_b(IO[15:8]),
				  .wren_a(w_en_a),
				  .wren_b(w_en_b),
				  .q_a(data_out_a[i]),
				  .q_b(data_out_b[i]));							  
end
endgenerate 									 

sort_5 st(.clk(clk_s), 
		    .rst(start_d),
		    .theta(theta),
		    .phi(phi),
		    .score_rdy(score_rdy),
		    .score_alpha_num(score_alpha_num),
		    .score(score),
		    .compare_num(compare_num),
			 .if_last_angle(if_last_angle), // need to wait until angle arrive sort
		    .candidate_angle_buffer(candidate_angle_buffer));

////////////////////////////////////////////////////ram for 1 clk end///////////////////////////////////////////////////////////////////
					
////////////////////////////////////////////////*****ram for stall 5 clk*****/////////////////////////////////////////////////////////////////

//wire [7:0] data_out_a_tem, data_out_b_tem;
//wire [14:0] addr_a, addr_b;
//wire cal_point_rdy
//
//ram_control rc(.start(start),
//					.clk(clk),
//					.rst(rst),
//					.addr(addr),
//					.new_xi(new_xi),
//					.new_yi(new_yi),
//					.new_xo(new_xo),
//					.new_yo(new_yo),
//					.xb_o(xb_o),
//					.yb_o(yb_o),
//					.cal_point_rdy(cal_point_rdy),
//					.addr_a(addr_a),
//					.addr_b(addr_b),
//					.w_en_a(w_en_a),
//					.w_en_b(w_en_b));
//
//ram_roi rr(.address_a(addr_a),
//			  .address_b(addr_b),
//			  .clock(clk),
//			  .data_a(IO[7:0]),
//			  .data_b(IO[15:8]),
//			  .wren_a(w_en_a),
//			  .wren_b(w_en_b),
//			  .q_a(data_out_a_tem),
//			  .q_b(data_out_b_tem));
//			  
//score_cal_point_buffer scpb(.clk(clk),
//									 .rst(rst),
//									 .cal_point_rdy(cal_point_rdy),
//									 .data_out_a_tem(data_out_a_tem),
//									 .data_out_b_tem(data_out_b_tem),
//									 .data_out_a_all({data_out_a[4], data_out_a[3], data_out_a[2], data_out_a[1], data_out_a[0]}),
//									 .data_out_b_all({data_out_b[4], data_out_b[3], data_out_b[2], data_out_b[1], data_out_b[0]}));
//
//sort st(.clk(clk), 
//		  .rst(rst),
//		  .theta(theta),
//		  .phi(phi),
//		  .score_rdy(score_rdy),
//		  .score_alpha_num(score_alpha_num),
//		  .score(score),
//		  .compare_num(compare_num),
//		  .if_last_angle(if_last_angle), // need to wait until angle arrive sort
//		  .candidate_angle_buffer(candidate_angle_buffer));
							  
									 
////////////////////////////////////////////////////ram for stall 5 clk end///////////////////////////////////////////////////////////////////

score_cal#(.width(8),.tanh_ex(19))
			scl(.point_val({data_out_b[3], data_out_b[2], data_out_b[1], data_out_b[0], 
								 data_out_a[3], data_out_a[2], data_out_a[1], data_out_a[0], data_out_a[4]}),  // out4, out3, out2, out1, in4, in3, in2, in1, boundary    
				 .clk(clk_s),
				 .rst(start_d),
				 .score(score));



//always@(posedge clk, negedge start_d)
//begin
//	if(!start_d)
//	begin	
//		best_angle_to_sram <= 24'h888888;
//	end
//	else if(addr == 20'h34bf)
//	begin
//		best_angle_to_sram <= {{8{1'b0}},sram_data_in[15:0]};
//	end
//	else
//	begin
//		best_angle_to_sram <= best_angle_to_sram;
//	end
//end
				 
seven_seg s1(.Din(candidate_angle_buffer[3:0]),
				 .Dout(seven1));

seven_seg s2(.Din(candidate_angle_buffer[7:4]),
				 .Dout(seven2)); 

seven_seg s3(.Din(candidate_angle_buffer[11:8]),
				 .Dout(seven3));

seven_seg s4(.Din(candidate_angle_buffer[15:12]),
				 .Dout(seven4)); 

seven_seg s5(.Din(candidate_angle_buffer[19:16]),
				 .Dout(seven5));

seven_seg s6(.Din(candidate_angle_buffer[23:20]),
				 .Dout(seven6)); 				 

seven_seg s7(.Din(addr[3:0]),
				 .Dout(seven7));

seven_seg s8(.Din(addr[7:4]),
				 .Dout(seven8));					 
endmodule						 