module degree_range(degree, degree_range);
input [11:0] degree;
output [1:0] degree_range;

assign degree_range = (degree<=900)?(2'd0):(degree<=1800)?(2'd1):(degree<=2700)?(2'd2):(2'd3);

endmodule