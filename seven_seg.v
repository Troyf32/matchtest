module seven_seg(Din, Dout);
input [3:0] Din;
output reg [6:0] Dout;

always@(Din)
begin
	case(Din)
		4'b0000: Dout = ~7'b0111111;
		4'b0001: Dout = ~7'b0000110;
		4'b0010: Dout = ~7'b1011011;
		4'b0011: Dout = ~7'b1001111;
		4'b0100: Dout = ~7'b1100110;
		4'b0101: Dout = ~7'b1101101;
		4'b0110: Dout = ~7'b1111101;
		4'b0111: Dout = ~7'b0000111;
		4'b1000: Dout = ~7'b1111111;
		4'b1001: Dout = ~7'b1101111;
		4'b1010: Dout = ~7'b1110111;
		4'b1011: Dout = ~7'b1111100;
		4'b1100: Dout = ~7'b0111001;
		4'b1101: Dout = ~7'b1011110;
		4'b1110: Dout = ~7'b1111001;
		4'b1111: Dout = ~7'b1110001;
	endcase
end

endmodule