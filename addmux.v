module addmux(row,
				  col,
				  addr,
				  clk);

input [8:0] row; 
input [9:0] col;
input clk;
output reg [19:0] addr;
reg [8:0] row_reg; 
reg [9:0] col_reg;
wire [19:0] mux_line;
wire [11:0] addr_line;

always@(posedge clk)
begin	
	row_reg <= row;
	col_reg <= col;
end

//assign mux_line = row_reg * 10'd800;
assign mux_line = row_reg * 11'd1200;
assign addr_line = col_reg + {1'b0, col_reg[9:1]}; 

always@(posedge clk)
begin
	//addr <= mux_line[19:10] + col_reg; 
	addr <= mux_line + {{(20-12){1'b0}},addr_line};
end

endmodule
				 