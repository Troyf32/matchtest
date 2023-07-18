module change_test(clk,
						 rst,
						 H,
						 L,
						 IO);
						 
input clk, rst;
output reg [7:0] H, L;
output reg [15:0] IO;
wire ena, enb, enc;
reg [3:0] cnt;
reg [7:0] L_tem;

assign ena = (cnt == 7)?1'b1:1'b0;
assign enb = (cnt == 8)?1'b1:1'b0;
assign enc = (cnt == 9)?1'b1:1'b0;

always@(posedge clk, negedge rst)
begin 
	if(!rst)
	begin
		H <= 8'd0;
		L <= 8'd0;
		IO <= 16'd0;
	end
	else if(ena)
	begin
		H <= 8'd2;
		L <= 8'd0;
		IO <= 16'd0;
	end
	else if(enb)
	begin
		H <= 8'd0;
		L <= 8'd3;
		IO <= 16'd0;
	end
	else if(enc)
	begin
		H <= 8'd0;
		L <= 8'd0;
		IO <= {H,L_tem};
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
		L_tem <= 8'd0;
	else
		L_tem <= L;
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
		cnt <= 4'd0;
	else if(cnt == 4'b1111)
		cnt <= 4'd0;
	else
		cnt <= cnt + 1'b1;
end


endmodule						 