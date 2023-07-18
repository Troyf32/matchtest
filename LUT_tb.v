`timescale 1ns/1ns
module LUT_tb();
reg [9:0] degree;
reg clk;
wire [9:0] value;
integer fp_w, i;

sinLUT_test sLt(.degree(degree),
				    .clk(clk),
				    .value(value));

always#20 clk = ~clk;
initial
begin
	//fp_w = $fopen("sin_value.txt", "w");
	clk = 1'b0;
	degree = 10'd0;
	//$fwrite(fp_w, "time\degree\value\n");
	for(i=1;i<=900;i=i+1)
	begin
		#40
		//$fwrite(fp_w, "%6t\t%x\t%x\n", $time, degree, value);
		degree = degree + 1'b1;
	end
	//$fclose(fp_w);
	$stop;
end

endmodule