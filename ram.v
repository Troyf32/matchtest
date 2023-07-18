module ram(input [16:0]addr_a, 
			  input [16:0]addr_b,
			  input [7:0] data_in_a,
			  input [7:0] data_in_b,
			  input clk,
			  input w_en_a,
			  input w_en_b,
			  output [7:0]data_out_a,
			  output [7:0]data_out_b);
			  
wire w_en_a_1, w_en_a_2;
wire w_en_b_1, w_en_b_2;
wire ifm1_a, ifm1_b;
wire [16:0] addr_a_m2, addr_b_m2;
wire [7:0] data_out_a_m1, data_out_a_m2, data_out_b_m1, data_out_b_m2;
assign ifm1_a = (addr_a < 17'd65536)?1'b1:1'b0;
assign ifm1_b = (addr_b < 17'd65536)?1'b1:1'b0;
assign addr_a_m2 = addr_a-17'd65536;
assign addr_b_m2 = addr_b-17'd65536;

MUX #(.m(1),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
  wa1(.pdata({w_en_a,1'b0}),
      .s(ifm1_a),
      .data_o(w_en_a_1));
MUX #(.m(1),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
  wa2(.pdata({1'b0,w_en_a}),
      .s(ifm1_a),
      .data_o(w_en_a_2));
MUX #(.m(1),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
  wb1(.pdata({w_en_b,1'b0}),
      .s(ifm1_b),
      .data_o(w_en_b_1));
MUX #(.m(1),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
  wb2(.pdata({1'b0,w_en_b}),
      .s(ifm1_b),
      .data_o(w_en_b_2));
MUX #(.m(8),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
   da(.pdata({data_out_a_m1,data_out_a_m2}),
      .s(ifm1_a),
      .data_o(data_out_a));
MUX #(.m(8),    // tem_value 10bit
      .n(2),     // 2 input
      .width(1)) // 1bit select
   db(.pdata({data_out_b_m1,data_out_b_m2}),
      .s(ifm1_b),
      .data_o(data_out_b));

memory m1(.address_a(addr_a[15:0]),
			 .address_b(addr_b[15:0]),
			 .clock(clk),
			 .data_a(data_in_a),
			 .data_b(data_in_b),
			 .wren_a(w_en_a_1),
			 .wren_b(w_en_b_1),
			 .q_a(data_out_a_m1),
			 .q_b(data_out_b_m1));
				
memory2 m2(.address_a(addr_a_m2[13:0]),
			  .address_b(addr_b_m2[13:0]),
			  .clock(clk),
			  .data_a(data_in_a),
			  .data_b(data_in_b),
			  .wren_a(w_en_a_2),
			  .wren_b(w_en_b_2),
			  .q_a(data_out_a_m2),
			  .q_b(data_out_b_m2));

endmodule