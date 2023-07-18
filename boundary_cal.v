module boundary_cal #(parameter N=21, parameter M=13)(rE, xc, yc, theta, phi, alpha, xb, yb, tau, clk, rst);
input clk;
input rst;
input [M-1:0] rE;				// 512  取小數點後4bit(9+4bit)
input [7:0] tau;
input [13:0] xc, yc;			// 1024 取小數點後4bit(10+4bit) xc 0~648 yc 0~488
input [11:0] theta, phi; 	// 4096 (0~3600)
input [11:0] alpha;			// 4096 (0~3600)
output reg[13:0] xb, yb;

//wire [N-1:0] tau_reg;		// 取小數點後8bit
//wire [7:0] tau_wire;		// 取小數點後8bit
//wire res_rdy, data_rdy; 	// tau cal finished
reg [M-1:0] rIr [7:0];		// 512  取小數點後4bit(9+4bit)
reg [7:0] taur [1:0];
reg [13:0] xcr [8:0], ycr [8:0];
reg [M-1:0] rEr [8:0];
wire [N-1:0] rI_shift;
wire [9:0] c_th_value_line, c_al_value_line, s_th_value_line, c_ph_value_line, s_al_value_line, s_ph_value_line, add1, p1, p2;
reg [9:0] c_th_value, c_al_value, s_th_value, c_ph_value, s_al_value, s_ph_value;
reg [9:0] c_ph_valuer [5:0], s_ph_valuer [5:0], s_th_valuer [4:0];
wire [9:0] c_ph_value_tmp, s_ph_value_tmp, s_th_value_tmp;
reg [9:0]  add1r;
wire [9:0] ctca, tctca_line, tqst, sasp, tsasp, sacp, tsacp;
reg [9:0] tctcar [4:0];
wire [15:0] tau_2_pre, tau_2_line, sq_in_line, radical;
reg [15:0] sq_in;
wire [7:0] tau_sq_line;
//reg [7:0] tau_sq;
wire [19:0] ctca_pre, tctca_pre, tqst_pre, sasp_pre, tsasp_pre, tsacp_pre, sacp_pre, p1_pre, p2_pre;
wire [9:0] sec_allx, sec_ally;
reg [9:0] sec_allxr, sec_allyr;
reg [9:0] tsaspr [5:0], tsacpr [5:0];
wire [M+9:0] xb_dis_line, yb_dis_line;
wire [13:0] xb_4, yb_4;
wire[13:0] xb_line, yb_line;


integer i;

assign c_ph_value_tmp = c_ph_valuer[5];
assign s_ph_value_tmp = s_ph_valuer[5];
assign s_th_value_tmp = s_th_valuer[4];

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		taur[0] <= 8'd0;
		taur[1] <= 8'd0;
		rEr[0] <= 13'd0;
		rEr[1] <= 13'd0;
		rEr[2] <= 13'd0;
		rEr[3] <= 13'd0;
		rEr[4] <= 13'd0;
		rEr[5] <= 13'd0;
		rEr[6] <= 13'd0;
		rEr[7] <= 13'd0;
		rEr[8] <= 13'd0;
		xcr[0] <= 14'd0;
		xcr[1] <= 14'd0;
		xcr[2] <= 14'd0;
		xcr[3] <= 14'd0;
		xcr[4] <= 14'd0;
		xcr[5] <= 14'd0;
		xcr[6] <= 14'd0;
		xcr[7] <= 14'd0;
		xcr[8] <= 14'd0;
		ycr[0] <= 14'd0;
		ycr[1] <= 14'd0;
		ycr[2] <= 14'd0;
		ycr[3] <= 14'd0;
		ycr[4] <= 14'd0;
		ycr[5] <= 14'd0;
		ycr[6] <= 14'd0;
		ycr[7] <= 14'd0;
		ycr[8] <= 14'd0;
		xb <= 14'd0;
		yb <= 14'd0;
	end
	else
	begin
		taur[0] <= tau;
		taur[1] <= taur[0];
		rEr[0] <= rE;
		rEr[1] <= rEr[0];
		rEr[2] <= rEr[1];
		rEr[3] <= rEr[2];
		rEr[4] <= rEr[3];
		rEr[5] <= rEr[4];
		rEr[6] <= rEr[5];
		rEr[7] <= rEr[6];
		rEr[8] <= rEr[7];
		xcr[0] <= xc;
		xcr[1] <= xcr[0];
		xcr[2] <= xcr[1];
		xcr[3] <= xcr[2];
		xcr[4] <= xcr[3];
		xcr[5] <= xcr[4];
		xcr[6] <= xcr[5];
		xcr[7] <= xcr[6];
		xcr[8] <= xcr[7];
		ycr[0] <= yc;
		ycr[1] <= ycr[0];
		ycr[2] <= ycr[1];
		ycr[3] <= ycr[2];
		ycr[4] <= ycr[3];
		ycr[5] <= ycr[4];
		ycr[6] <= ycr[5];
		ycr[7] <= ycr[6];
		ycr[8] <= ycr[7];
		xb <= xb_line;
		yb <= yb_line;
	end
end

always@(posedge clk, negedge rst) 
begin
	if(!rst)
	begin
		sq_in <= 16'd0;
		tctcar[0] <= 10'd0;
		tctcar[1] <= 10'd0;
		tctcar[2] <= 10'd0;
		tctcar[3] <= 10'd0;
		tctcar[4] <= 10'd0;
		add1r <= 10'd0;
		tsaspr[0] <= 10'd0;
		tsaspr[1] <= 10'd0;
		tsaspr[2] <= 10'd0;
		tsaspr[3] <= 10'd0;
		tsaspr[4] <= 10'd0;
		tsaspr[5] <= 10'd0;
		tsacpr[0] <= 10'd0;
		tsacpr[1] <= 10'd0;
		tsacpr[2] <= 10'd0;
		tsacpr[3] <= 10'd0;
		tsacpr[4] <= 10'd0;
		tsacpr[5] <= 10'd0;
		sec_allxr <= 10'd0;
		sec_allyr <= 10'd0;
	end
	else
	begin
		sq_in <= sq_in_line;
		tctcar[0] <= tctca_line;
		tctcar[1] <= tctcar[0];
		tctcar[2] <= tctcar[1];
		tctcar[3] <= tctcar[2];
		tctcar[4] <= tctcar[3];
		add1r <= add1;
		tsaspr[0] <= tsasp;
		tsaspr[1] <= tsaspr[0];
		tsaspr[2] <= tsaspr[1];
		tsaspr[3] <= tsaspr[2];
		tsaspr[4] <= tsaspr[3];
		tsaspr[5] <= tsaspr[4];
		tsacpr[0] <= tsacp;
		tsacpr[1] <= tsacpr[0];
		tsacpr[2] <= tsacpr[1];
		tsacpr[3] <= tsacpr[2];
		tsacpr[4] <= tsacpr[3];
		tsacpr[5] <= tsacpr[4];	
		sec_allxr <= sec_allx;
		sec_allyr <= sec_ally;
		//tau_sq <= tau_sq_line;
	end
end


always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		c_th_value <= 10'd0;
		c_al_value <= 10'd0;
		s_th_value <= 10'd0;
		c_ph_value <= 10'd0;
		s_al_value <= 10'd0;
		s_ph_value <= 10'd0;
		c_ph_valuer[0] <= 10'd0;
		c_ph_valuer[1] <= 10'd0;
		c_ph_valuer[2] <= 10'd0;
		c_ph_valuer[3] <= 10'd0;
		c_ph_valuer[4] <= 10'd0;
		c_ph_valuer[5] <= 10'd0;
		s_ph_valuer[0] <= 10'd0;
		s_ph_valuer[1] <= 10'd0;
		s_ph_valuer[2] <= 10'd0;
		s_ph_valuer[3] <= 10'd0;
		s_ph_valuer[4] <= 10'd0;
		s_ph_valuer[5] <= 10'd0;
		s_th_valuer[0] <= 10'd0;
		s_th_valuer[1] <= 10'd0;
		s_th_valuer[2] <= 10'd0;
		s_th_valuer[3] <= 10'd0;
		s_th_valuer[4] <= 10'd0;
	end
	else
	begin
		c_th_value <= c_th_value_line;
		c_al_value <= c_al_value_line;
		s_th_value <= s_th_value_line;
		c_ph_value <= c_ph_value_line;
		s_al_value <= s_al_value_line;
		s_ph_value <= s_ph_value_line;
		c_ph_valuer[0] <= c_ph_value;
		c_ph_valuer[1] <= c_ph_valuer[0];
		c_ph_valuer[2] <= c_ph_valuer[1];
		c_ph_valuer[3] <= c_ph_valuer[2];
		c_ph_valuer[4] <= c_ph_valuer[3];
		c_ph_valuer[5] <= c_ph_valuer[4];
		s_ph_valuer[0] <= s_ph_value;
		s_ph_valuer[1] <= s_ph_valuer[0];
		s_ph_valuer[2] <= s_ph_valuer[1];
		s_ph_valuer[3] <= s_ph_valuer[2];
		s_ph_valuer[4] <= s_ph_valuer[3];
		s_ph_valuer[5] <= s_ph_valuer[4];
		s_th_valuer[0] <= s_th_value;
		s_th_valuer[1] <= s_th_valuer[0];
		s_th_valuer[2] <= s_th_valuer[1];
		s_th_valuer[3] <= s_th_valuer[2];
		s_th_valuer[4] <= s_th_valuer[3];
	end
end

//MUX #(.m(8),     // tau 8bit
//      .n(2),     // 2 input
//      .width(1)) // 1bit select
// muxt(.pdata({tau_tem,8'b0}),
//      .s(res_rdy),
//      .data_o(tau));


trigonometric cth(.degree(theta),
					   .clk(clk),
					   .value(c_th_value_line),
					   .iscos(1'b1));
	
trigonometric cph(.degree(phi),
					   .clk(clk),
					   .value(c_ph_value_line),
					   .iscos(1'b1));
						
trigonometric cal(.degree(alpha),
					   .clk(clk),
					   .value(c_al_value_line),
					   .iscos(1'b1));

trigonometric sth(.degree(theta),
					   .clk(clk),
					   .value(s_th_value_line),
					   .iscos(1'b0));
						
trigonometric sph(.degree(phi),
					   .clk(clk),
					   .value(s_ph_value_line),
					   .iscos(1'b0));						
						
trigonometric sal(.degree(alpha),
					   .clk(clk),
					   .value(s_al_value_line),
					   .iscos(1'b0));

sqrt_16bit sq(.clk(clk),
				  .radical(sq_in),
				  .q(tau_sq_line),
				  .remainder());
			 
//x						 
assign ctca_pre = {{10{c_th_value[9]}},c_th_value}*{{10{c_al_value[9]}},c_al_value};
assign ctca = ctca_pre[17:8];
assign tctca_pre = {12'b0,taur[1]}*{{10{ctca[9]}},ctca};
assign tctca_line = tctca_pre[17:8];	

assign tau_2_pre = taur[1]**2;
assign tau_2_line = tau_2_pre[15:8];
assign sq_in_line = 16'd256-tau_2_line;
assign tqst_pre = {8'b0,tau_sq_line,4'b0}*{{10{s_th_value_tmp[9]}},s_th_value_tmp};
assign tqst = tqst_pre[17:8];
assign add1 = tctcar[4]+tqst;
assign p1_pre = {{10{add1r[9]}},add1r}*{{10{c_ph_value_tmp[9]}},c_ph_value_tmp};
assign p1 = p1_pre[17:8];	

assign sasp_pre = {{10{s_al_value[9]}},s_al_value}*{{10{s_ph_value[9]}},s_ph_value};
assign sasp = sasp_pre[17:8];
assign tsasp_pre = {12'b0,taur[1]}*{{10{sasp[9]}},sasp};
assign tsasp = tsasp_pre[17:8];
//

//y	
assign p2_pre = {{10{add1r[9]}},add1r}*{{10{s_ph_value_tmp[9]}},s_ph_value_tmp};
assign p2 = p2_pre[17:8];	

assign sacp_pre = {{10{s_al_value[9]}},s_al_value}*{{10{c_ph_value[9]}},c_ph_value};
assign sacp = sacp_pre[17:8];
assign tsacp_pre = {12'b0,taur[1]}*{{10{sacp[9]}},sacp};
assign tsacp = tsacp_pre[17:8];
//

				 
assign sec_allx = p1-tsaspr[5];	
assign sec_ally = p2+tsacpr[5];							 
assign xb_dis_line = {10'b0,rEr[8]}*{{M{sec_allxr[9]}},sec_allxr};
assign yb_dis_line = {10'b0,rEr[8]}*{{M{sec_allyr[9]}},sec_allyr};
assign xb_4 = xcr[8] + xb_dis_line[21:8];
assign yb_4 = ycr[8] - yb_dis_line[21:8];
//assign xb = xb_4[13:4];
//assign yb = yb_4[13:4];
assign xb_line = xb_4[13:0];
assign yb_line = yb_4[13:0];
			
endmodule