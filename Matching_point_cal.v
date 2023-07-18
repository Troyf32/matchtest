module Matching_point_cal(clk,
								  rst,
								  theta,
								  phi,
								  alpha,
								  xc,
								  yc,
								  tau,
								  rE,
								  new_xi,
								  new_yi,
								  new_xo,
								  new_yo,
								  xb_o,
								  yb_o);
								  
parameter N = 39;
parameter width = 14;

input clk;
input rst;
input [11:0] theta;
input [11:0] phi;
input [11:0] alpha;
input [13:0] xc, yc;
input [7:0] tau;
input [12:0] rE;
output [width*4-1:0] new_xi, new_yi, new_xo, new_yo;
output [width-1:0] xb_o, yb_o;

wire [13:0] xc_new, yc_new;
wire [13:0] iris_center_x, iris_center_y;
wire [13:0] xb, yb;

assign xc_new = xc - 14'd1776;
assign yc_new = yc - 14'd176;

IrisCenter_cal #(.width(10))
				  ic(.theta(theta),
					  .phi(phi),
					  .rE(rE), 
					  .x(xc_new),  //eye center
					  .y(yc_new),  //eye center
					  .clk(clk),
					  .rst(rst),
					  .iris_center_x(iris_center_x),
					  .iris_center_y(iris_center_y));

boundary_cal #(.N(21),
					.M(13))
				bc(.rE(rE), 
					.xc(xc_new), 	//eye center
					.yc(yc_new), 	//eye center
					.theta(theta), 
					.phi(phi), 
					.alpha(alpha), 
					.xb(xb), 
					.yb(yb), 
					.tau(tau), 
					.clk(clk),
					.rst(rst));	

point_cal #(.width(14))
			pc(.xc(iris_center_x),
				.yc(iris_center_y),
				.xb(xb),
				.yb(yb),
				.clk(clk),
				.rst(rst),
				.new_xi(new_xi),
				.new_yi(new_yi),
				.new_xo(new_xo),
				.new_yo(new_yo),
				.xb_o(xb_o),
				.yb_o(yb_o)); 
		  		
endmodule