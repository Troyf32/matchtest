module reverse2 #(parameter BIT = 10)(neg, pos);
input [BIT-1:0] neg;
output [BIT-1:0] pos;

assign pos= ~(neg-1'b1);

endmodule