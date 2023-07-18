module atan#(parameter width = 10)
				(y, 
				 x, 
				 clk, 
				 degree);
input [width-1:0] y, x; //xb-xc yb-yc 10bits (-512~511)
input clk;
output [11:0] degree; // ()

wire [width-1:0] x_d, y_d, tem_x, tem_y, pos_x, pos_y, tem_degree;

assign tem_x = -x;
assign tem_y = -y;
			  
shift_reg #(.shift_num(1),
				.width(width))
			rx(.clk(clk),
			   .rst(),
			   .in(x),
				.out(x_d));
		
shift_reg #(.shift_num(1),
				.width(width))
		   ry(.clk(clk),
			   .rst(),
			   .in(y),
				.out(y_d));
			 
MUX #(.m(width), 	// x 10bit
      .n(2),     	// 2 input
      .width(1)) 	// 1bit select
 muxx(.pdata({tem_x,x}),
      .s(x[width-1]),
      .data_o(pos_x));	
		
MUX #(.m(width),  // y 10bit
      .n(2),     	// 2 input
      .width(1)) 	// 1bit select
 muxy(.pdata({tem_y,y}),
      .s(y[width-1]),
      .data_o(pos_y));	
			  
atan_LUT al(.address({pos_y[9:3],pos_x[9:3]}),
				.clock(clk),
				.q(tem_degree));
				
MUX #(.m(12),    // degree 12bit
      .n(4),     // 4 input
      .width(2)) // 2bit select
 muxs(.pdata({12'd1800+{2'b0,tem_degree},12'd1800-{2'b0,tem_degree},12'd3600-{2'b0,tem_degree},{2'b0,tem_degree}}),
      .s({x_d[width-1],y_d[width-1]}),
      .data_o(degree));	
		
endmodule