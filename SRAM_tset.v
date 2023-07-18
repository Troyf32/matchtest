module SRAM_tset(clk,button,start,rst,CE_n,OE_n,WE_n,UB_n,LB_n,addr,IO,seven1,seven2,seven3,seven4,seven5,seven6,seven7,seven8,LEDR0, LEDR1, LEDR2, LEDR3, LEDR4);
input clk, rst, start;
inout [15:0] IO;
input button;
output reg WE_n;
output reg CE_n,OE_n,UB_n,LB_n;
output reg [19:0] addr;
output [6:0]seven1;
output [6:0]seven2;
output [6:0]seven3;
output [6:0]seven4;
output [6:0]seven5;
output [6:0]seven6;
output [6:0]seven7;
output [6:0]seven8;
output reg LEDR0;
output reg LEDR1;
output reg LEDR2;
output reg LEDR3;
output reg LEDR4;

reg [15:0] in_value;

reg [19:0] addr_cnt;
reg [15:0] best_angle;

wire enable;

	initial
	begin
		LEDR4 <= 1'd1;
		LEDR3 <= 1'd0;
		LEDR2 <= 1'd0;
		LEDR1 <= 1'd0;
		LEDR0 <= 1'd0;
	end

 always@(posedge clk)
 begin
	if(enable&start)
	begin
		LEDR4 <= ~LEDR4;
		LEDR3 <= ~LEDR3;
	end
	else
	begin
		LEDR4 <= LEDR4;
		LEDR3 <= LEDR3;
	end
 end

Debounce db(.buttonin(button),
				.clicked(enable),
				.clk(clk),
				.r(rst));

//assign IO=WE_n?16'd0:16'h66;

initial
begin
	addr <= 20'd0;
end


always@(posedge enable, negedge rst)
begin
	if(!rst)
		addr <= 20'd0;
	else if(start) 
		addr <= addr + 20'h34bf;
	else
		addr <= addr;
end

always@(*)
begin
	CE_n <= 1'b0;
	OE_n <= 1'b0;
	UB_n <= 1'b0;
	LB_n <= 1'b0;
	WE_n <= 1'b1;
end
//assign WE_n = 1'b1;


seven_seg s1(.Din(IO[3:0]),
				 .Dout(seven1));

seven_seg s2(.Din(IO[7:4]),
				 .Dout(seven2)); 

seven_seg s3(.Din(IO[11:8]),
				 .Dout(seven3));

seven_seg s4(.Din(IO[15:12]),
				 .Dout(seven4)); 

seven_seg s5(.Din(addr[3:0]),
				 .Dout(seven5));

seven_seg s6(.Din(addr[7:4]),
				 .Dout(seven6)); 				 

seven_seg s7(.Din(addr[11:8]),
				 .Dout(seven7));

seven_seg s8(.Din(addr[15:12]),
				 .Dout(seven8));				 
				 
always@(posedge enable, negedge rst)
begin
	if(!rst)
	begin
		addr_cnt <= 0;
	end
	else if(addr_cnt <= 4'd9)
	begin
		addr_cnt <= addr_cnt + 1'd1;
	end
	else
	begin
		addr_cnt <= 1'd0;
	end
end
				 
//sram_controllor sc (.clk(enable),.WE_n(WE_n),.cnt(addr_cnt));				 
				 
endmodule