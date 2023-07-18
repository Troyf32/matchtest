`timescale 1ns/1ns
module reverse_tb();
reg [10:0] pos;
wire [10:0] neg;

reverse #(.BIT(11))
		  us(.pos(pos),
			  .neg(neg));

initial
begin
	pos = 11'b00110010001;
	#10
	pos = 11'b00110010010;
	#10
	pos = 11'b00110010011;
	#10
	pos = 11'b00110010100;
	#10
	pos = 11'b00110010101;
end
					
endmodule