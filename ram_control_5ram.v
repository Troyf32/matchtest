module ram_control_5ram #(parameter width = 14)
						       (start,
						        clk,
							     rst,
							     addr,
						        new_xi,
							     new_yi,
							     new_xo,
							     new_yo,
							     xb_o,
							     yb_o,
							     addr_a_5,
							     addr_b_5,
							     w_en_a_5,
							     w_en_b_5);

input start;							
input clk;
input rst;
input [19:0] addr;
input [width*4-1:0] new_xi, new_yi, new_xo, new_yo; //point 14 bit output addr 15 bit
input [width-1:0] xb_o, yb_o;
output [15*5-1:0] addr_a_5, addr_b_5;
output w_en_a_5;
output w_en_b_5;
wire [14:0] addr_a_w, addr_b_w;
wire [17:0] addr_a_line_tem [4:0], addr_b_line_tem [4:0];
wire [14:0] addr_a_line [4:0], addr_b_line [4:0];
wire [14:0] addr_a_tem, addr_b_tem;
wire roi_input_rdy; // data_input_rdy

assign roi_input_rdy = (addr<20'h34bc)?1'b0:1'b1;  // until eye_data
//assign data_input_rdy = (addr<20'h34bf)?1'b0:1'b1;  // include eye_data
assign w_en_a_5 = ((start)&(roi_input_rdy))?1'b0:1'b1;
assign w_en_b_5 = ((start)&(roi_input_rdy))?1'b0:1'b1; 

assign addr_a_w = {addr[13:0],1'b0};
assign addr_b_w = {addr[13:0],1'b1}; 

assign addr_a_line_tem[0] = {{8'b0,{new_yi[(width-1)-:10]}}*18'd180+{8'b0,new_xi[(width-1)-:10]}};  // new_xi 14-4 bit  180 8 bit
assign addr_a_line[0] = addr_a_line_tem[0][14:0];
assign addr_a_line_tem[1] = {{8'b0,{new_yi[(width*2-1)-:10]}}*18'd180+{8'b0,new_xi[(width*2-1)-:10]}};
assign addr_a_line[1] = addr_a_line_tem[1][14:0];
assign addr_a_line_tem[2] = {{8'b0,{new_yi[(width*3-1)-:10]}}*18'd180+{8'b0,new_xi[(width*3-1)-:10]}};
assign addr_a_line[2] = addr_a_line_tem[2][14:0];
assign addr_a_line_tem[3] = {{8'b0,{new_yi[(width*4-1)-:10]}}*18'd180+{8'b0,new_xi[(width*4-1)-:10]}};
assign addr_a_line[3] = addr_a_line_tem[3][14:0];
assign addr_a_line_tem[4] = {{8'b0,{yb_o[13:4]}}*17'd180+{7'b0,xb_o[13:4]}};
assign addr_a_line[4] = addr_a_line_tem[4][14:0];
assign addr_b_line_tem[0] = {{8'b0,{new_yo[(width-1)-:10]}}*18'd180+{8'b0,new_xo[(width-1)-:10]}};
assign addr_b_line[0] = addr_b_line_tem[0][14:0];
assign addr_b_line_tem[1] = {{8'b0,{new_yo[(width*2-1)-:10]}}*18'd180+{8'b0,new_xo[(width*2-1)-:10]}};
assign addr_b_line[1] = addr_b_line_tem[1][14:0];
assign addr_b_line_tem[2] = {{8'b0,{new_yo[(width*3-1)-:10]}}*18'd180+{8'b0,new_xo[(width*3-1)-:10]}};
assign addr_b_line[2] = addr_b_line_tem[2][14:0];
assign addr_b_line_tem[3] = {{8'b0,{new_yo[(width*4-1)-:10]}}*18'd180+{8'b0,new_xo[(width*4-1)-:10]}};
assign addr_b_line[3] = addr_b_line_tem[3][14:0];
assign addr_b_line_tem[4] = {{8'b0,{yb_o[13:4]}}*18'd180+{8'b0,xb_o[13:4]}};
assign addr_b_line[4] = addr_b_line_tem[4][14:0];	

genvar i;
generate
for(i=0;i<5;i=i+1)
begin:ad
	
	MUX #(.m(15),    // addr 15bit
			.n(2),     // 2 input
			.width(1)) // 1bit select
	ewa(.pdata({addr_a_w, addr_a_line[i]}),
			.s(w_en_a_5),
			.data_o(addr_a_5[(i+1)*15-1-:15]));
	
	MUX #(.m(15),    // addr 15bit
			.n(2),     // 2 input
			.width(1)) // 1bit select
	ewb(.pdata({addr_b_w, addr_b_line[i]}),
			.s(w_en_b_5),
			.data_o(addr_b_5[(i+1)*15-1-:15]));
end
endgenerate

endmodule