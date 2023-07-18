module ram_test(input [16:0]addr_a, 
					 input [16:0]addr_b,
					 input [7:0] data_in_a,
					 input [7:0] data_in_b,
					 input clk,
					 input w_en_a,
					 input w_en_b,
					 output reg [7:0]data_out_a,
					 output reg [7:0]data_out_b);
					 
//reg [16:0] addr_ar;
//reg [16:0] addr_br;
//reg [7:0] data_in_ar;
//reg [7:0] data_in_br;
wire [7:0] data_out_a_wire;
wire [7:0] data_out_b_wire;					 

always@(posedge clk)
begin
	//addr_ar <= addr_a;
	//addr_br <= addr_b;
	//data_in_ar <= data_in_a;
	//data_in_br <= data_in_b;
	data_out_a <= data_out_a_wire;
	data_out_b <= data_out_b_wire;
end

ram r(.addr_a(addr_a), 
	   .addr_b(addr_b),
	   .data_in_a(data_in_a),
	   .data_in_b(data_in_b),
	   .clk(clk),
	   .w_en_a(w_en_a),
	   .w_en_b(w_en_b),
	   .data_out_a(data_out_a_wire),
	   .data_out_b(data_out_b_wire));
		
endmodule					 