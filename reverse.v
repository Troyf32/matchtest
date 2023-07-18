module reverse #(parameter BIT = 10)(pos, neg);
input [BIT-1:0] pos;
output [BIT-1:0] neg;

assign neg= ~pos+1'b1;

endmodule