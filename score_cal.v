module score_cal#(
						parameter width = 8,
						parameter tanh_ex = width+11
						)
					 (
					  input [width*9-1:0] point_val,  // out4(width*9), out3(width*8), out2(width*7), out1(width*6), in4(width*5), in3(width*4), in2(width*3), in1(width*2), boundary(width*1)    
					  input clk,
					  input rst,
					  output reg [width+12:0] score // after integer 8bit  total 21bit
					  );  

wire [width+2:0] out3, out5, outside, out4_d50, in3, in5, in5_d;
wire [width+10:0] out5_shift;
wire [width+10:0] out5_shift_d;
wire [9:0] tanh_val, tanh_val_add;
wire [9:0] tanh_val_d;
wire res_rdy;
wire [width+10:0] pre_score, pre_score_line; //19bit
wire [width+20:0] score_shift; //21bit

assign out3 = {{3'b0},point_val[width*8-1:width*7]} + {{3'b0},point_val[width*7-1:width*6]} + {{3'b0},point_val[width*6-1:width*5]}; // score*2 circle
assign in3  = {{3'b0},point_val[width*4-1:width*3]} + {{3'b0},point_val[width*3-1:width*2]} + {{3'b0},point_val[width*2-1:width]};
assign outside = out3 + {{3'b0},point_val[width-1:0]};
assign out4_d50 = (outside[width+2:2]>9'd50)?{2'b0,outside[width+2:2]} - 11'd50:{2'b0,outside[width+2:2]}; //outside_value/4-50
assign out5 = {out3[width+1:0],1'b0} + {{3'b0},point_val[width*9-1:width*8]} + {{3'b0},point_val[width-1:0]} + 1'b1;
assign in5 = {in3[width+1:0],1'b0} + {{3'b0},point_val[width*5-1:width*4]} + {{3'b0},point_val[width-1:0]} + 1'b1;
assign out5_shift = out5 << 8;


tanh_LUT tl(.address(out4_d50[7:0]), //[7:0]    
			   .clock(clk),
			   .q(tanh_val));   // tanh_val has been divided 64 and shift left 8 bit
				
shift_reg #(.shift_num(1),
				.width(tanh_ex))
		 ov5d(.clk(clk),
			   .rst(rst),
			   .in(out5_shift),
				.out(out5_shift_d));
				
shift_reg #(.shift_num(1),
				.width(11))
		 iv5d(.clk(clk),
			   .rst(rst),
			   .in(in5),
				.out(in5_d));				

shift_reg #(.shift_num(19),
				.width(10))
		   td(.clk(clk),
			   .rst(rst),
			   .in(tanh_val),
				.out(tanh_val_d));

divider_man #(.N(width+11), .M(width+3)) //N:被除數 M:除數 取到小數後8bit
	 u_divider(.clk (clk),
				  .rstn (rst),
				  .data_rdy (1'b1),
				  .dividend (out5_shift_d),
				  .divisor (in5_d),
				  .res_rdy (res_rdy),
				  .merchant (pre_score),
				  .remainder ());
				  
//MUX #(.m(width+11),// tem_degree width+10 bit
//      .n(2),     // 2 input
//      .width(1)) // 1bit select
//  scm(.pdata({{tanh_ex{1'b0}},pre_score_line}),
//      .s(~res_rdy),
//      .data_o(pre_score));  ////pre_score not sure if it has been delayed
		
assign tanh_val_add = tanh_val_d + 10'd256;
assign score_shift = {10'b0,pre_score} * {{tanh_ex{1'b0}},tanh_val_add};


always@(posedge clk)
begin
	score <= score_shift[width+20:8];
	//score <= score_shift[width+12:0];
end

endmodule					  