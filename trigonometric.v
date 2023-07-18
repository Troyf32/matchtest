module trigonometric(degree, clk, value, iscos);
input [11:0] degree; //0~4095
input clk, iscos;
output [9:0] value;  //0~1023 
wire [11:0] tem_degree;
wire [11:0] degreesin90, degreecos90;
wire [9:0] tem_value, tem_value_re;
wire [9:0] tem_sin_value, tem_cos_value;
wire sin_reverse, sin_reverse_d, cos_reverse, cos_reverse_d;
wire [1:0]degree_range;

assign sin_reverse = (degree_range>=2'd2)?1'b1:1'b0;
assign cos_reverse = ((degree_range==2'd1)|(degree_range==2'd2))?1'b1:1'b0;

shift_reg #(.shift_num(1),
				.width(1))
			sr(.clk(clk),
			   .rst(1'b1),
			   .in(sin_reverse),
				.out(sin_reverse_d));

shift_reg #(.shift_num(1),
				.width(1))
			cr(.clk(clk),
			   .rst(1'b1),
			   .in(cos_reverse),
				.out(cos_reverse_d));

MUX #(.m(12),    // tem_degree 12bit
      .n(4),     // 4 input
      .width(2)) // 2bit select
 muxs(.pdata({12'd3600-degree,degree-12'd1800,12'd1800-degree,degree}),
      .s(degree_range),
      .data_o(degreesin90));
MUX #(.m(12),    // tem_degree 12bit
      .n(4),     // 4 input
      .width(2)) // 2bit select
 muxc(.pdata({degree-12'd2700,12'd2700-degree,degree-12'd900,12'd900-degree}),
      .s(degree_range),
      .data_o(degreecos90));		
MUX #(.m(12),    // tem_degree 12bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
 mux1(.pdata({degreecos90,degreesin90}),
      .s(iscos),
      .data_o(tem_degree));
MUX #(.m(10),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
 mux2(.pdata({tem_value_re,tem_value}),
      .s(cos_reverse_d),
      .data_o(tem_cos_value));
MUX #(.m(10),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
 mux3(.pdata({tem_value_re,tem_value}),
      .s(sin_reverse_d),
      .data_o(tem_sin_value));
MUX #(.m(10),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
 mux4(.pdata({tem_cos_value,tem_sin_value}),
      .s(iscos),
      .data_o(value));

degree_range dr(.degree(degree),
					 .degree_range(degree_range));

sine_LUT sL(.address(tem_degree[9:0]),
				.clock(clk),
				.q(tem_value));

assign tem_value_re = -tem_value;	
				
//reverse #(.BIT(10))
//		 re(.pos(tem_value),
//			 .neg(tem_value_re));
			 
endmodule
//always@(*)
//begin
//	case(degree_range)
//	2'b00 : 
//	begin
//		degreesin90 <= degree;
//		degreecos90 <= 900-degree;
//	end
//	2'b01 : 
//	begin
//		degreesin90 <= 1800-degree;
//		degreecos90 <= degree-900;
//	end
//	2'b10 : 
//	begin
//		degreesin90 <= degree-1800;
//		degreecos90 <= 2700-degree;
//	end
//	2'b11 : 
//	begin
//		degreesin90 <= 3600-degree;
//		degreecos90 <= degree-2700;
//	end
//	default : 
//		{degreesin90, degreecos90} <= 24'd0;
//	endcase
//end
//assign tem_degree = iscos?degreecos90:degreesin90;
//assign value = iscos?cos_reverse?tem_value_re:tem_value:sin_reverse?tem_value_re:tem_value;