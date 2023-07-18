module sram_controllor(start, 
							  clk,
							  rst,
							  addr, 
							  CE_n,
							  OE_n,
							  WE_n,
							  UB_n,
							  LB_n,
							  sram_data_in,
							  xc,
							  yc,
							  tau,
							  rE,
							  best_angle_rdy,
							  candidate_angle_buffer,
							  best_angle);

input start;
input clk;
input rst;
input best_angle_rdy; 
input [23:0] candidate_angle_buffer;
input [15:0] sram_data_in;
output [11:0] best_angle;
output reg [19:0] addr;
output reg CE_n, OE_n, WE_n, UB_n, LB_n;
output reg [13:0] xc, yc;
output reg [7:0] tau;
output reg [12:0] rE;

wire [19:0] sram_addr_w;

reg w_angle_cnt;
reg [1:0] w_cnt;

always@(posedge clk)
begin
	CE_n <= 1'b0;
	OE_n <= 1'b0;
	UB_n <= 1'b0;
	LB_n <= 1'b0;
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		xc <= 14'd0;
		yc <= 14'd0;
		rE <= 13'd0;
		tau <= 8'd0;
	end
	else if((addr==20'h34bc)&(WE_n))
	begin
		xc <= sram_data_in[13:0];
		yc <= yc;
		rE <= rE;
		tau <= tau;
	end
	else if((addr==20'h34bd)&(WE_n))
	begin
		yc <= sram_data_in[13:0];
		xc <= xc;
		rE <= rE;
		tau <= tau;
	end
	else if((addr==20'h34be)&(WE_n))
	begin
		rE <= sram_data_in[12:0];
		xc <= xc;
		yc <= yc;
		tau <= tau;
	end
	else if((addr==20'h34bf)&(WE_n))
	begin
		tau <= sram_data_in[7:0];
		xc <= xc;
		yc <= yc;
		rE <= rE;
	end
	else
	begin
		xc <= xc;
		yc <= yc;
		rE <= rE;
		tau <= tau;
	end
end

always@(posedge clk , negedge rst)
begin
	if(!rst)
	begin
		w_angle_cnt <= 1'b0;
	end
	else if(best_angle_rdy)
	begin
		w_angle_cnt <= 1'b1;
	end
	else
	begin
		w_angle_cnt <= 1'b0;
	end
end

MUX #(.m(20),    // addr_theta, addr_phi 20 bit*2
      .n(2),     // 2 input
      .width(1)) // 1bit select
  adc(.pdata({20'h34c1,20'h34c0}),
      .s(w_angle_cnt),          
      .data_o(sram_addr_w));


always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		addr <= 20'd0;
	end
	else if((start)&(addr<20'h34bf)) // (13504-1)
	begin
		addr <= addr + 1'b1;
	end
	else if(best_angle_rdy)
	begin
		addr <= sram_addr_w;
	end
	else
	begin
		addr <= addr;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		w_cnt <= 2'b0;
	end
	else if(best_angle_rdy&(w_cnt<2'd2))
	begin
		w_cnt <= w_cnt + 1'b1;
	end
	else
	begin
		w_cnt <= w_cnt;
	end
end

always@(posedge clk)
begin
	if(best_angle_rdy&(w_cnt<2'd2))
	begin
		WE_n <= 1'b0;
	end
	else
	begin
		WE_n <= 1'b1;
	end
end


assign best_angle = (w_cnt==2'd1)?candidate_angle_buffer[23:12]:candidate_angle_buffer[11:0];	// needs improvement

endmodule