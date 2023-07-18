module sinLUT_test(degree, clk, value, iscos);
input [11:0] degree; //0~4096
input clk, iscos;
output reg[9:0] value;
reg [11:0] degreewire;
reg coswire;
wire [9:0] valuewire;
always@(posedge clk)
begin
	degreewire <= degree;
	coswire <= iscos;
	value <= valuewire;
end

trigonometric sL(.degree(degreewire),
					  .clk(clk),
					  .value(valuewire),
					  .iscos(coswire));
endmodule				
