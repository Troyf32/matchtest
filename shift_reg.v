module shift_reg#(parameter shift_num = 20,parameter width = 24)
					  (clk,
					   rst,
					   in,
						out);
						
input clk, rst;
input [width-1:0] in;
output [width-1:0] out;
reg [width-1:0] shift [shift_num-1:0];
integer i;

initial
begin
	for(i=0;i<shift_num;i=i+1)
	begin
		shift[i] <= {width{1'b0}};
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		for(i=0;i<shift_num;i=i+1)
		begin
			shift[i] <= {width{1'b0}};
		end
	end
	else
	begin
		shift[0] <= in;
		for(i=0;i<shift_num-1;i=i+1)
		begin
			shift[i+1] <= shift[i];
		end
	end
end

assign out = shift[shift_num-1];

endmodule