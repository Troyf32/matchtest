//module match_cal #(parameter width = 10)
//					 (input [width-1:0] xc,       //湔
//					  input [width-1:0] yc,
//					  input [width-1:0] xb,
//					  input [width-1:0] yb,
//					  input clk,
//					  output reg[15:0] score);   
//wire [width-1:0] x_dis, y_dis;
//wire [9:0] co_value_line, si_value_line;
//wire [11:0] degree;
//reg [width-1:0] xi, yi [3:0];
//reg [width-1:0] xo, yo [4:0];
//wire[width-1:0] xi_line, yi_line [3:0];
//wire[width-1:0] xo_line, yo_line [4:0];
//reg [width-1:0] co_value, si_value;
//wire [15:0] co_value_tem, si_value_tem [3:0];
//wire [15:0] in_value [3:0];
//wire [15:0] out_value [4:0];
//wire [15:0] out_value_all, in_value_all, outside_value_all;
//wire [15:0] tanh_in;
//wire cal_en;
//reg [15:0] compensate;
//
//assign x_dis = xb-xc;   // {x_dis,y_dis} 第 三 二 四 一 象限
//assign y_dis = yb-yc;
//
//assign co_value_tem[0] = (co_value * 3)>>>8;
//assign si_value_tem[0] = (si_value * 3)>>>8;
//assign co_value_tem[1] = (co_value * 6)>>>8;
//assign si_value_tem[1] = (si_value * 6)>>>8;
//assign co_value_tem[2] = (co_value * 9)>>>8;
//assign si_value_tem[2] = (si_value * 9)>>>8;
//assign co_value_tem[3] = (co_value * 12)>>>8;
//assign si_value_tem[3] = (si_value * 12)>>>8;
//
//assign xo_line[0] = xb;    					 		 		  // 0 * 3 
//assign yo_line[0] = yb;    					 		 		  // 0 * 3 
//assign xi_line[0] = xb;    					 		 		  // 0 * 3 
//assign yi_line[0] = yb;    					 		 		  // 0 * 3 
//assign xo_line[1] = xb + co_value_tem[0][width-1:0];    // 1 * 3 
//assign yo_line[1] = yb + si_value_tem[0][width-1:0];    // 1 * 3 
//assign xi_line[1] = xb - co_value_tem[0][width-1:0];    // 1 * 3 
//assign yi_line[1] = yb - si_value_tem[0][width-1:0];    // 1 * 3 
//assign xo_line[2] = xb + co_value_tem[1][width-1:0];    // 2 * 3 
//assign yo_line[2] = yb + si_value_tem[1][width-1:0];    // 2 * 3 
//assign xi_line[2] = xb - co_value_tem[1][width-1:0];    // 2 * 3 
//assign yi_line[2] = yb - si_value_tem[1][width-1:0];    // 2 * 3 
//assign xo_line[3] = xb + co_value_tem[2][width-1:0];    // 3 * 3 
//assign yo_line[3] = yb + si_value_tem[2][width-1:0];    // 3 * 3 
//assign xi_line[3] = xb - co_value_tem[2][width-1:0];    // 3 * 3 
//assign yi_line[3] = yb - si_value_tem[2][width-1:0];    // 3 * 3
//assign xo_line[4] = xb + co_value_tem[3][width-1:0];    // 4 * 3 
//assign yo_line[4] = yb + si_value_tem[3][width-1:0];    // 4 * 3 
//
//assign cal_en = ((xo[4]>0)&&(yo[4]>0)&&(xo[4]<200)&&(yo[4]<380))?1'b1:1'b0; //if within region
//
//assign out_value_all = out_value[0] + out_value[1] + out_value[2] + out_value[3] + out_value[4] + 1'b1;
//assign in_value_all = in_value[0] + in_value[1] + in_value[2] + in_value[3] + 1'b1;
//assign outside_value_all = out_value[0] + out_value[1] + out_value[2] + out_value[3] + 1'b1;
//assign tanh_in = outside_value_all >>> 6 + 1'b1;
//
//always@(posedge clk)
//begin
//	//reg1
//	co_value <= co_value_line; 
//	si_value <= si_value_line;
//	//reg2
//	xo[0] = xo_line[0];
//	yo[0] = yo_line[0];
//	xi[0] = xi_line[0];
//	yi[0] = yi_line[0];
//	xo[1] = xo_line[1];
//	yo[1] = yo_line[1];
//	xi[1] = xi_line[1];
//	yi[1] = yi_line[1];
//	xo[2] = xo_line[2];
//	yo[2] = yo_line[2];
//	xi[2] = xi_line[2];
//	yi[2] = yi_line[2];
//	xo[3] = xo_line[3];
//	yo[3] = yo_line[3];
//	xi[3] = xi_line[3];
//	yi[3] = yi_line[3];
//	xo[4] = xo_line[4];
//	yo[4] = yo_line[4];	
//	
//end
//
//atan at(.y(y_dis),
//		  .x(x_dis),
//		  .clk(clk),
//		  .degree(degree));
//
//tanh th(.tanh_in(tanh_in),
//		  .clk(clk),
//		  .tanh_val(compensate));
//
//trigonometric co(.degree(degree),
//					  .clk(clk),
//					  .value(co_value_line),
//					  .iscos(1'b1));
//
//trigonometric si(.degree(degree),
//					  .clk(clk),
//					  .value(si_value_line),
//					  .iscos(1'b0));						
//
//genvar i;
//generate 		  
//for(i=0;i<4;i=i+1)
//begin:pv
//	p_val  pvi(.x(xi[i]),
//				  .y(yi[i]),
//				  .clk(clk),
//				  .point_val(in_value[i]));	
//	p_val  pvo(.x(xo[i]),
//				  .y(yo[i]),
//				  .clk(clk),
//				  .point_val(out_value[i]));	
//end
//endgenerate
//p_val  pvo0(.x(xo[4]),
//			   .y(yo[4]),
//			   .clk(clk),
//			   .point_val(out_value[i]));	
//			 
//always@(posedge clk)
//begin
//	score <= score * compensate;
//end
//						
//endmodule  