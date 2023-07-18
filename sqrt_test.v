module sqrt_test(input [15:0] radical,
					  input clk,
					  output reg [7:0]  q,
					  output reg [8:0]  remainder);

reg [15:0] radical_r;
wire [7:0]  q_line;
wire [8:0]  remainder_line;


always@(posedge clk)
begin
	radical_r	<= radical;
	q			<= q_line;
	remainder	<= remainder_line;
end

sqrt_16bit ssq(.clk(clk),
					.radical(radical_r),
				   .q(q_line),
				   .remainder(remainder_line));
					
endmodule					