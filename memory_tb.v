`timescale 1ns/1ns
module memory_tb();
reg [16:0] addr_a;
reg [16:0] addr_b;
reg [7:0] data_in_a;
reg [7:0] data_in_b;
reg clk;
reg w_en_a, w_en_b;
wire [7:0] data_out_a;
wire [7:0] data_out_b;
integer i, j, cnt, fp_r, fp_w;

ram r(.addr_a(addr_a), 
		.addr_b(addr_b),
		.data_in_a(data_in_a),
		.data_in_b(data_in_b),
		.clk(clk),
		.w_en_a(w_en_a),
		.w_en_b(w_en_b),
		.data_out_a(data_out_a),
		.data_out_b(data_out_b));

always#10 clk = ~clk;		  
initial
begin
	clk = 1'b0;
	w_en_a = 1'b1;
	w_en_b = 1'b0;
//	data_in_a = 8'd30;
//	data_in_b = 8'd255;
//	addr_a = 17'd48462;
//	addr_b = 17'd70000;
//	#40
//	w_en_a = 1'b0;
//	w_en_b = 1'b0;
//	data_in_a = 8'd1;
//	data_in_b = 8'd8;
//	addr_a = 17'd48462;
//	addr_b = 17'd70000;
//	#40
//	addr_a = 17'd48462;
//	addr_b = 17'd70000;
//	#40
//	w_en_a = 1'b1;
//	w_en_b = 1'b1;
//	data_in_a = 8'd3;
//	data_in_b = 8'd8;
//	addr_a = 17'd48462;
//	addr_b = 17'd70000;
//	#40
//	addr_a = 17'd48462;
//	addr_b = 17'd70000;

fp_r = $fopen("D:/eyetrack_troy/cvproject/cvproject/sram_data.txt", "r"); //D:/eyetrack_troy/cvproject/cvproject/

	for(i=0;i<150;i=i+1)
	begin
		for(j=0;j<180;j=j+1)
		begin
			#20
			addr_a <= i*180 + j;
			cnt <= $fscanf(fp_r, "%x", data_in_a); 
		end
	end	
$fclose(fp_r);
	w_en_a = 1'b0;
//	fp_w = $fopen("D:/eyetrack_troy/cvproject/cvproject/sram_roi_data.txt", "w"); //D:/eyetrack_troy/cvproject/cvproject/
//	for(i=0;i<150;i=i+1)
//	begin
//		for(j=0;j<180;j=j+1)
//		begin
//			addr_a <= i*180 + j;
//			#20
//			$fwrite(fp_w, "%x\n", data_out_a); 
//		end
//	end
//	
//$fclose(fp_w);
end			  

endmodule