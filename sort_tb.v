`timescale 1ns/1ns
module sort_tb();
reg clk, rst, score_rdy;
reg [11:0] theta;
reg [11:0] phi;
reg [8:0] score_alpha_num;
reg [16:0] score;
reg [3:0] compare_num;
wire [11:0] theta_out [9:0];
wire [11:0] phi_out [9:0];
wire [7:0] score_buffer [9:0];
wire [16:0] score_tem;
wire [8:0] score_alpha_cnt;
reg [31:0] cnt; 
//wire [2:0] stall_cnt;
wire compare_rdy;
wire compare_data_rdy;
wire [7:0] score_in;
wire [7:0] score_in_compare;
wire [3:0] index;
wire [3:0] compare_cnt;
wire if_last_angle;
wire [7:0] score_in_shift;
integer i;

assign score_tem = sort_tb.st.score_tem;
//assign stall_cnt = sort_tb.st.stall_cnt;
assign score_tem = sort_tb.st.score_tem;
assign index = sort_tb.st.index;
assign compare_cnt = sort_tb.st.c1.compare_cnt;
assign compare_data_rdy = sort_tb.st.compare_data_rdy;
assign compare_rdy = sort_tb.st.compare_rdy;
assign score_in = sort_tb.st.c1.score_in;
assign score_in_compare = sort_tb.st.score_in;
assign score_alpha_cnt = sort_tb.st.score_alpha_cnt;
assign score_in_shift = sort_tb.st.score_in_shift;

genvar j;
generate
for(j=0;j<10;j=j+1)
begin:s
	assign score_buffer[j] = sort_tb.st.score_buffer[j*8+7-:8];
end
endgenerate

always@(posedge clk)
begin
	cnt <= cnt + 1'b1;
end
 
always#10 clk = ~clk;
initial
begin
	cnt <= 32'd0;
	clk <= 1'b1;
	rst <= 1'b1;
	score_rdy <= 1'b0;
	theta <= 12'd190;
	phi <= 12'd320;
	score_alpha_num <= 9'd12;
	compare_num <= 4'd6;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	score_rdy <= 1'b1;
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
		for(i=0;i<40;i=i+1)
		begin
			#20
			theta <= 12'd1 * i;
			phi <= 12'd2 * i;
			score <= 17'd63 * i;
		end
	#20
	theta <= 12'd33;
	phi <= 12'd44;
	score <= 17'd513;
	#20
	theta <= 12'd55;
	phi <= 12'd66;
	score <= 17'd843;
	#20
	theta <= 12'd77;
	phi <= 12'd88;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd22;
	phi <= 12'd33;
	score <= 17'd810;
	#20
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
	#20
	theta <= 12'd32;
	phi <= 12'd43;
	score <= 17'd513;
	#20
	theta <= 12'd56;
	phi <= 12'd65;
	score <= 17'd843;
	#20
	theta <= 12'd76;
	phi <= 12'd86;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd27;
	phi <= 12'd37;
	score <= 17'd810;
	#20
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
	#20
	theta <= 12'd31;
	phi <= 12'd42;
	score <= 17'd513;
	#20
	theta <= 12'd52;
	phi <= 12'd62;
	score <= 17'd843;
	#20
	theta <= 12'd78;
	phi <= 12'd89;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd228;
	phi <= 12'd38;
	score <= 17'd810;
	#20
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
	#20
	theta <= 12'd33;
	phi <= 12'd44;
	score <= 17'd513;
	#20
	theta <= 12'd55;
	phi <= 12'd66;
	score <= 17'd843;
	#20
	theta <= 12'd77;
	phi <= 12'd88;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd22;
	phi <= 12'd33;
	score <= 17'd810;
	#20
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
	#20
	theta <= 12'd32;
	phi <= 12'd43;
	score <= 17'd513;
	#20
	theta <= 12'd56;
	phi <= 12'd65;
	score <= 17'd843;
	#20
	theta <= 12'd76;
	phi <= 12'd86;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd27;
	phi <= 12'd37;
	score <= 17'd810;
	#20
	theta <= 12'd11;
	phi <= 12'd22;
	score <= 17'd612;
	#20
	theta <= 12'd31;
	phi <= 12'd42;
	score <= 17'd513;
	#20
	theta <= 12'd52;
	phi <= 12'd62;
	score <= 17'd843;
	#20
	theta <= 12'd78;
	phi <= 12'd89;
	score <= 17'd244;
	#20
	theta <= 12'd99;
	phi <= 12'd11;
	score <= 17'd946;
	#20
	theta <= 12'd228;
	phi <= 12'd38;
	score <= 17'd810;
	////////////////////////////
	//score <= 17'd5;
	//#20
	//score <= 17'd9;
	//#20
	//score <= 17'd4;
	//#20
	//score <= 17'd6;
	//#20
	//score <= 17'd15;
	//#20
	//theta <= 12'd11;
	//phi <= 12'd22;
	//score <= 17'd19;
	//#20
	//score <= 17'd8;
	//#20
	//score <= 17'd9;
	//#20
	//theta <= 12'd20;
	//phi <= 12'd33;
	//score <= 17'd2;
	//#20
	//score <= 17'd8;
	//#20
	//theta <= 12'd33;
	//phi <= 12'd44;
	//score <= 17'd10;
	//#20
	//score <= 17'd8;
	//#20
	//score <= 17'd7;
	//#20
	//theta <= 12'd10;
	//phi <= 12'd30;
	//score <= 17'd5;
	//#20
	//score <= 17'd5;
	//#20
	//score <= 17'd6;
	//#20
	//score <= 17'd3;
	//#20
	//score <= 17'd4;
	//#20
	//score <= 17'd1;
	//#20
	//score <= 17'd11;
	//#20
	//score <= 17'd3;
	//#20
	//theta <= 12'd210;
	//phi <= 12'd330;
	//score <= 17'd0;
	//#20
	//score <= 17'd29;
	//#20
	//score <= 17'd5;
	//#20
	//score <= 17'd21;
	//#20
	//score <= 17'd17;
	//#20
	//score <= 17'd14;
	//#20
	//score <= 17'd20;
	//#20
	//score <= 17'd12;
	//#20
	//score <= 17'd6;
	//#20
	//score <= 17'd9;
	//#20
	//score <= 17'd2;
	//#20
	//theta <= 12'd510;
	//phi <= 12'd40;
	//score <= 17'd1;
	//#20
	//score <= 17'd8;
	//#20
	//score <= 17'd7;
	//#20
	//score <= 17'd3;
	//#20
	//score <= 17'd5;
	//#20
	//score <= 17'd6;
	//#20
	//score <= 17'd7;
	//#20
	//score <= 17'd4;
	//#20
	//score <= 17'd1;
	#20000
	$stop;
end 
 
sort_5 st(.clk(clk), 
		  .rst(rst),
		  .theta(theta),
		  .phi(phi),
		  .score_rdy(score_rdy),
		  .score_alpha_num(score_alpha_num),
		  .score(score),
		  .compare_num(compare_num),
		  .if_last_angle(if_last_angle),
		  .candidate_angle_buffer({theta_out[9],phi_out[9],theta_out[8],phi_out[8],theta_out[7],phi_out[7],theta_out[6],phi_out[6],theta_out[5],phi_out[5],
											theta_out[4],phi_out[4],theta_out[3],phi_out[3],theta_out[2],phi_out[2],theta_out[1],phi_out[1],theta_out[0],phi_out[0]}));
					  
endmodule

//parameter quantity = 128;
//parameter width = 8;
//reg [quantity*width-1:0] candidate;
//reg clk;
////wire[3:0]index_sorted[quantity-1:0];
////wire[quantity*width-1:0] sorted;
////wire [width-1:0] sorted0;
////wire [width-1:0] sorted1;
////wire [width-1:0] sorted2;
////wire [width-1:0] sorted3;
////wire [width-1:0] sorted4;
////wire [width-1:0] sorted5;
////wire [width-1:0] sorted6;
////wire [width-1:0] sorted7;
////wire [width-1:0] sorted8;
////wire [width-1:0] sorted9;
////wire [width-1:0] sorted10;
////wire [width-1:0] sorted11;
////wire [width-1:0] sorted12;
////wire [width-1:0] sorted13;
////wire [width-1:0] sorted14;
////wire [width-1:0] sorted15;
//wire [width-1:0] sorted0;
//wire [width-1:0] sorted1;
//wire [width-1:0] sorted2;
//wire [width-1:0] sorted3;
//wire [width-1:0] sorted4;
//wire [width-1:0] sorted5;
//wire [width-1:0] sorted6;
//wire [width-1:0] sorted7;
//wire [width-1:0] sorted8;
//wire [width-1:0] sorted9;
//wire [width-1:0] sorted10;
//wire [width-1:0] sorted11;
//wire [width-1:0] sorted12;
//wire [width-1:0] sorted13;
//wire [width-1:0] sorted14;
//wire [width-1:0] sorted15;
//wire [width-1:0] sorted16;
//wire [width-1:0] sorted17;
//wire [width-1:0] sorted18;
//wire [width-1:0] sorted19;
//wire [width-1:0] sorted20;
//wire [width-1:0] sorted21;
//wire [width-1:0] sorted22;
//wire [width-1:0] sorted23;
//wire [width-1:0] sorted24;
//wire [width-1:0] sorted25;
//wire [width-1:0] sorted26;
//wire [width-1:0] sorted27;
//wire [width-1:0] sorted28;
//wire [width-1:0] sorted29;
//wire [width-1:0] sorted30;
//wire [width-1:0] sorted31;
//wire [width-1:0] sorted32;
//wire [width-1:0] sorted33;
//wire [width-1:0] sorted34;
//wire [width-1:0] sorted35;
//wire [width-1:0] sorted36;
//wire [width-1:0] sorted37;
//wire [width-1:0] sorted38;
//wire [width-1:0] sorted39;
//wire [width-1:0] sorted40;
//wire [width-1:0] sorted41;
//wire [width-1:0] sorted42;
//wire [width-1:0] sorted43;
//wire [width-1:0] sorted44;
//wire [width-1:0] sorted45;
//wire [width-1:0] sorted46;
//wire [width-1:0] sorted47;
//wire [width-1:0] sorted48;
//wire [width-1:0] sorted49;
//wire [width-1:0] sorted50;
//wire [width-1:0] sorted51;
//wire [width-1:0] sorted52;
//wire [width-1:0] sorted53;
//wire [width-1:0] sorted54;
//wire [width-1:0] sorted55;
//wire [width-1:0] sorted56;
//wire [width-1:0] sorted57;
//wire [width-1:0] sorted58;
//wire [width-1:0] sorted59;
//wire [width-1:0] sorted60;
//wire [width-1:0] sorted61;
//wire [width-1:0] sorted62;
//wire [width-1:0] sorted63;
//wire [width-1:0] sorted64;
//wire [width-1:0] sorted65;
//wire [width-1:0] sorted66;
//wire [width-1:0] sorted67;
//wire [width-1:0] sorted68;
//wire [width-1:0] sorted69;
//wire [width-1:0] sorted70;
//wire [width-1:0] sorted71;
//wire [width-1:0] sorted72;
//wire [width-1:0] sorted73;
//wire [width-1:0] sorted74;
//wire [width-1:0] sorted75;
//wire [width-1:0] sorted76;
//wire [width-1:0] sorted77;
//wire [width-1:0] sorted78;
//wire [width-1:0] sorted79;
//wire [width-1:0] sorted80;
//wire [width-1:0] sorted81;
//wire [width-1:0] sorted82;
//wire [width-1:0] sorted83;
//wire [width-1:0] sorted84;
//wire [width-1:0] sorted85;
//wire [width-1:0] sorted86;
//wire [width-1:0] sorted87;
//wire [width-1:0] sorted88;
//wire [width-1:0] sorted89;
//wire [width-1:0] sorted90;
//wire [width-1:0] sorted91;
//wire [width-1:0] sorted92;
//wire [width-1:0] sorted93;
//wire [width-1:0] sorted94;
//wire [width-1:0] sorted95;
//wire [width-1:0] sorted96;
//wire [width-1:0] sorted97;
//wire [width-1:0] sorted98;
//wire [width-1:0] sorted99;
//wire [width-1:0] sorted100;
//wire [width-1:0] sorted101;
//wire [width-1:0] sorted102;
//wire [width-1:0] sorted103;
//wire [width-1:0] sorted104;
//wire [width-1:0] sorted105;
//wire [width-1:0] sorted106;
//wire [width-1:0] sorted107;
//wire [width-1:0] sorted108;
//wire [width-1:0] sorted109;
//wire [width-1:0] sorted110;
//wire [width-1:0] sorted111;
//wire [width-1:0] sorted112;
//wire [width-1:0] sorted113;
//wire [width-1:0] sorted114;
//wire [width-1:0] sorted115;
//wire [width-1:0] sorted116;
//wire [width-1:0] sorted117;
//wire [width-1:0] sorted118;
//wire [width-1:0] sorted119;
//wire [width-1:0] sorted120;
//wire [width-1:0] sorted121;
//wire [width-1:0] sorted122;
//wire [width-1:0] sorted123;
//wire [width-1:0] sorted124;
//wire [width-1:0] sorted125;
//wire [width-1:0] sorted126;
//wire [width-1:0] sorted127;
//
//wire [6:0] index_sorted0;
//wire [6:0] index_sorted1;
//wire [6:0] index_sorted2;
//wire [6:0] index_sorted3;
//wire [6:0] index_sorted4;
//wire [6:0] index_sorted5;
//wire [6:0] index_sorted6;
//wire [6:0] index_sorted7;
//wire [6:0] index_sorted8;
//wire [6:0] index_sorted9;
//wire [6:0] index_sorted10;
//wire [6:0] index_sorted11;
//wire [6:0] index_sorted12;
//wire [6:0] index_sorted13;
//wire [6:0] index_sorted14;
//wire [6:0] index_sorted15;
//wire [6:0] index_sorted16;
//wire [6:0] index_sorted17;
//wire [6:0] index_sorted18;
//wire [6:0] index_sorted19;
//wire [6:0] index_sorted20;
//wire [6:0] index_sorted21;
//wire [6:0] index_sorted22;
//wire [6:0] index_sorted23;
//wire [6:0] index_sorted24;
//wire [6:0] index_sorted25;
//wire [6:0] index_sorted26;
//wire [6:0] index_sorted27;
//wire [6:0] index_sorted28;
//wire [6:0] index_sorted29;
//wire [6:0] index_sorted30;
//wire [6:0] index_sorted31;
//wire [6:0] index_sorted32;
//wire [6:0] index_sorted33;
//wire [6:0] index_sorted34;
//wire [6:0] index_sorted35;
//wire [6:0] index_sorted36;
//wire [6:0] index_sorted37;
//wire [6:0] index_sorted38;
//wire [6:0] index_sorted39;
//wire [6:0] index_sorted40;
//wire [6:0] index_sorted41;
//wire [6:0] index_sorted42;
//wire [6:0] index_sorted43;
//wire [6:0] index_sorted44;
//wire [6:0] index_sorted45;
//wire [6:0] index_sorted46;
//wire [6:0] index_sorted47;
//wire [6:0] index_sorted48;
//wire [6:0] index_sorted49;
//wire [6:0] index_sorted50;
//wire [6:0] index_sorted51;
//wire [6:0] index_sorted52;
//wire [6:0] index_sorted53;
//wire [6:0] index_sorted54;
//wire [6:0] index_sorted55;
//wire [6:0] index_sorted56;
//wire [6:0] index_sorted57;
//wire [6:0] index_sorted58;
//wire [6:0] index_sorted59;
//wire [6:0] index_sorted60;
//wire [6:0] index_sorted61;
//wire [6:0] index_sorted62;
//wire [6:0] index_sorted63;
//wire [6:0] index_sorted64;
//wire [6:0] index_sorted65;
//wire [6:0] index_sorted66;
//wire [6:0] index_sorted67;
//wire [6:0] index_sorted68;
//wire [6:0] index_sorted69;
//wire [6:0] index_sorted70;
//wire [6:0] index_sorted71;
//wire [6:0] index_sorted72;
//wire [6:0] index_sorted73;
//wire [6:0] index_sorted74;
//wire [6:0] index_sorted75;
//wire [6:0] index_sorted76;
//wire [6:0] index_sorted77;
//wire [6:0] index_sorted78;
//wire [6:0] index_sorted79;
//wire [6:0] index_sorted80;
//wire [6:0] index_sorted81;
//wire [6:0] index_sorted82;
//wire [6:0] index_sorted83;
//wire [6:0] index_sorted84;
//wire [6:0] index_sorted85;
//wire [6:0] index_sorted86;
//wire [6:0] index_sorted87;
//wire [6:0] index_sorted88;
//wire [6:0] index_sorted89;
//wire [6:0] index_sorted90;
//wire [6:0] index_sorted91;
//wire [6:0] index_sorted92;
//wire [6:0] index_sorted93;
//wire [6:0] index_sorted94;
//wire [6:0] index_sorted95;
//wire [6:0] index_sorted96;
//wire [6:0] index_sorted97;
//wire [6:0] index_sorted98;
//wire [6:0] index_sorted99;
//wire [6:0] index_sorted100;
//wire [6:0] index_sorted101;
//wire [6:0] index_sorted102;
//wire [6:0] index_sorted103;
//wire [6:0] index_sorted104;
//wire [6:0] index_sorted105;
//wire [6:0] index_sorted106;
//wire [6:0] index_sorted107;
//wire [6:0] index_sorted108;
//wire [6:0] index_sorted109;
//wire [6:0] index_sorted110;
//wire [6:0] index_sorted111;
//wire [6:0] index_sorted112;
//wire [6:0] index_sorted113;
//wire [6:0] index_sorted114;
//wire [6:0] index_sorted115;
//wire [6:0] index_sorted116;
//wire [6:0] index_sorted117;
//wire [6:0] index_sorted118;
//wire [6:0] index_sorted119;
//wire [6:0] index_sorted120;
//wire [6:0] index_sorted121;
//wire [6:0] index_sorted122;
//wire [6:0] index_sorted123;
//wire [6:0] index_sorted124;
//wire [6:0] index_sorted125;
//wire [6:0] index_sorted126;
//wire [6:0] index_sorted127;
//
//
//integer i;
//
////batcher_odd_even_sort b(.candidate(candidate),
////								.clk(clk),
////								.index_sorted({index_sorted15,
////													index_sorted14, index_sorted13, index_sorted12, index_sorted11, index_sorted10, 
////													index_sorted9, index_sorted8, index_sorted7, index_sorted6, index_sorted5, 
////													index_sorted4, index_sorted3, index_sorted2, index_sorted1, index_sorted0}),
////								//.sorted({sorted15, sorted14, sorted13, sorted12, sorted11, sorted10, sorted9,
////								//	sorted8, sorted7, sorted6, sorted5, sorted4, sorted3, sorted2, sorted1, sorted0})
////								);
//
//batcher_odd_even_sort_128 aa(.candidate(candidate),
//								     .clk(clk),
//								     .index_sorted({index_sorted127, index_sorted126, index_sorted125,
//														  index_sorted124, index_sorted123, index_sorted122, index_sorted121, index_sorted120,
//														  index_sorted119, index_sorted118, index_sorted117, index_sorted116, index_sorted115,
//														  index_sorted114, index_sorted113, index_sorted112, index_sorted111, index_sorted110,
//														  index_sorted109, index_sorted108, index_sorted107, index_sorted106, index_sorted105,
//														  index_sorted104, index_sorted103, index_sorted102, index_sorted101, index_sorted100,
//														  index_sorted99,  index_sorted98,  index_sorted97,  index_sorted96,  index_sorted95,
//														  index_sorted94,  index_sorted93,  index_sorted92,  index_sorted91,  index_sorted90,
//														  index_sorted89,  index_sorted88,  index_sorted87,  index_sorted86,  index_sorted85,
//														  index_sorted84,  index_sorted83,  index_sorted82,  index_sorted81,  index_sorted80,
//														  index_sorted79,  index_sorted78,  index_sorted77,  index_sorted76,  index_sorted75,
//														  index_sorted74,  index_sorted73,  index_sorted72,  index_sorted71,  index_sorted70,
//														  index_sorted69,  index_sorted68,  index_sorted67,  index_sorted66,  index_sorted65,
//														  index_sorted64,  index_sorted63,  index_sorted62,  index_sorted61,  index_sorted60,
//														  index_sorted59,  index_sorted58,  index_sorted57,  index_sorted56,  index_sorted55,
//														  index_sorted54,  index_sorted53,  index_sorted52,  index_sorted51,  index_sorted50,
//														  index_sorted49,  index_sorted48,  index_sorted47,  index_sorted46,  index_sorted45,
//														  index_sorted44,  index_sorted43,  index_sorted42,  index_sorted41,  index_sorted40,
//														  index_sorted39,  index_sorted38,  index_sorted37,  index_sorted36,  index_sorted35,
//														  index_sorted34,  index_sorted33,  index_sorted32,  index_sorted31,  index_sorted30,
//														  index_sorted29,  index_sorted28,  index_sorted27,  index_sorted26,  index_sorted25,
//														  index_sorted24,  index_sorted23,  index_sorted22,  index_sorted21,  index_sorted20,
//														  index_sorted19,  index_sorted18,  index_sorted17,  index_sorted16,  index_sorted15,
//														  index_sorted14,  index_sorted13,  index_sorted12,  index_sorted11,  index_sorted10, 
//														  index_sorted9, 	 index_sorted8, 	index_sorted7,   index_sorted6, 	 index_sorted5, 
//														  index_sorted4, 	 index_sorted3, 	index_sorted2,   index_sorted1, 	 index_sorted0}),
//									  .sorted({sorted127, sorted126, sorted125,
//												  sorted124, sorted123, sorted122, sorted121, sorted120,
//												  sorted119, sorted118, sorted117, sorted116, sorted115,
//												  sorted114, sorted113, sorted112, sorted111, sorted110,
//												  sorted109, sorted108, sorted107, sorted106, sorted105,
//												  sorted104, sorted103, sorted102, sorted101, sorted100,
//												  sorted99,  sorted98,  sorted97,  sorted96,  sorted95,
//												  sorted94,  sorted93,  sorted92,  sorted91,  sorted90,
//												  sorted89,  sorted88,  sorted87,  sorted86,  sorted85,
//												  sorted84,  sorted83,  sorted82,  sorted81,  sorted80,
//												  sorted79,  sorted78,  sorted77,  sorted76,  sorted75,
//												  sorted74,  sorted73,  sorted72,  sorted71,  sorted70,
//												  sorted69,  sorted68,  sorted67,  sorted66,  sorted65,
//												  sorted64,  sorted63,  sorted62,  sorted61,  sorted60,
//												  sorted59,  sorted58,  sorted57,  sorted56,  sorted55,
//												  sorted54,  sorted53,  sorted52,  sorted51,  sorted50,
//												  sorted49,  sorted48,  sorted47,  sorted46,  sorted45,
//												  sorted44,  sorted43,  sorted42,  sorted41,  sorted40,
//												  sorted39,  sorted38,  sorted37,  sorted36,  sorted35,
//												  sorted34,  sorted33,  sorted32,  sorted31,  sorted30,
//												  sorted29,  sorted28,  sorted27,  sorted26,  sorted25,
//												  sorted24,  sorted23,  sorted22,  sorted21,  sorted20,
//												  sorted19,  sorted18,  sorted17,  sorted16,  sorted15,
//												  sorted14,  sorted13,  sorted12,  sorted11,  sorted10, 
//												  sorted9, 	 sorted8, 	sorted7,   sorted6, 	 sorted5, 
//												  sorted4, 	 sorted3, 	sorted2,   sorted1, 	 sorted0})
//								     );								
//
//always#10 clk = ~clk;
//initial
//begin
//	candidate = 0;
//	clk = 1'b1;
//	#15
////	for(i=0;i<quantity;i=i+1)
////	begin
////		candidate[((i+1)*width-1)-:width] = 8'd;
////	end
////	candidate[((0+1)*width-1)-:width] <= 8'd94;
////	candidate[((1+1)*width-1)-:width] <= 8'd63;
////	candidate[((2+1)*width-1)-:width] <= 8'd4;
////	candidate[((3+1)*width-1)-:width] <= 8'd119;
////	candidate[((4+1)*width-1)-:width] <= 8'd54;
////	candidate[((5+1)*width-1)-:width] <= 8'd74;
////	candidate[((6+1)*width-1)-:width] <= 8'd35;
////	candidate[((7+1)*width-1)-:width] <= 8'd100;
////	candidate[((8+1)*width-1)-:width] <= 8'd7;
////	candidate[((9+1)*width-1)-:width] <= 8'd153;
////	candidate[((10+1)*width-1)-:width] <= 8'd179;
////	candidate[((11+1)*width-1)-:width] <= 8'd66;
////	candidate[((12+1)*width-1)-:width] <= 8'd174;
////	candidate[((13+1)*width-1)-:width] <= 8'd69;
////	candidate[((14+1)*width-1)-:width] <= 8'd50;
////	candidate[((15+1)*width-1)-:width] <= 8'd49;
////	#10
//	candidate[((0+1)*width-1)-:width] <= 8'd94;
//	candidate[((1+1)*width-1)-:width] <= 8'd63;
//	candidate[((2+1)*width-1)-:width] <= 8'd14;
//	candidate[((3+1)*width-1)-:width] <= 8'd219;
//	candidate[((4+1)*width-1)-:width] <= 8'd54;
//	candidate[((5+1)*width-1)-:width] <= 8'd74;
//	candidate[((6+1)*width-1)-:width] <= 8'd35;
//	candidate[((7+1)*width-1)-:width] <= 8'd10;
//	candidate[((8+1)*width-1)-:width] <= 8'd71;
//	candidate[((9+1)*width-1)-:width] <= 8'd153;
//	candidate[((10+1)*width-1)-:width] <= 8'd179;
//	candidate[((11+1)*width-1)-:width] <= 8'd66;
//	candidate[((12+1)*width-1)-:width] <= 8'd17;
//	candidate[((13+1)*width-1)-:width] <= 8'd169;
//	candidate[((14+1)*width-1)-:width] <= 8'd50;
//	candidate[((15+1)*width-1)-:width] <= 8'd69;
//	candidate[((16+1)*width-1)-:width] <= 8'd35;
//	candidate[((17+1)*width-1)-:width] <= 8'd10;
//	candidate[((18+1)*width-1)-:width] <= 8'd71;
//	candidate[((19+1)*width-1)-:width] <= 8'd153;
//	candidate[((20+1)*width-1)-:width] <= 8'd179;
//	candidate[((21+1)*width-1)-:width] <= 8'd66;
//	candidate[((22+1)*width-1)-:width] <= 8'd17;
//	candidate[((23+1)*width-1)-:width] <= 8'd169;
//	candidate[((24+1)*width-1)-:width] <= 8'd50;
//	candidate[((25+1)*width-1)-:width] <= 8'd69;
//	candidate[((26+1)*width-1)-:width] <= 8'd35;
//	candidate[((27+1)*width-1)-:width] <= 8'd10;
//	candidate[((28+1)*width-1)-:width] <= 8'd71;
//	candidate[((29+1)*width-1)-:width] <= 8'd153;
//	candidate[((30+1)*width-1)-:width] <= 8'd179;
//	candidate[((31+1)*width-1)-:width] <= 8'd66;
//	candidate[((32+1)*width-1)-:width] <= 8'd17;
//	candidate[((33+1)*width-1)-:width] <= 8'd169;
//	candidate[((34+1)*width-1)-:width] <= 8'd50;
//	candidate[((35+1)*width-1)-:width] <= 8'd69;
//	candidate[((36+1)*width-1)-:width] <= 8'd35;
//	candidate[((37+1)*width-1)-:width] <= 8'd10;
//	candidate[((38+1)*width-1)-:width] <= 8'd71;
//	candidate[((39+1)*width-1)-:width] <= 8'd153;
//	candidate[((40+1)*width-1)-:width] <= 8'd179;
//	candidate[((41+1)*width-1)-:width] <= 8'd66;
//	candidate[((42+1)*width-1)-:width] <= 8'd17;
//	candidate[((43+1)*width-1)-:width] <= 8'd169;
//	candidate[((44+1)*width-1)-:width] <= 8'd50;
//	candidate[((45+1)*width-1)-:width] <= 8'd69;
//	candidate[((46+1)*width-1)-:width] <= 8'd35;
//	candidate[((47+1)*width-1)-:width] <= 8'd10;
//	candidate[((48+1)*width-1)-:width] <= 8'd71;
//	candidate[((49+1)*width-1)-:width] <= 8'd153;
//	candidate[((50+1)*width-1)-:width] <= 8'd179;
//	candidate[((51+1)*width-1)-:width] <= 8'd66;
//	candidate[((52+1)*width-1)-:width] <= 8'd17;
//	candidate[((53+1)*width-1)-:width] <= 8'd169;
//	candidate[((54+1)*width-1)-:width] <= 8'd50;
//	candidate[((55+1)*width-1)-:width] <= 8'd69;
//	candidate[((56+1)*width-1)-:width] <= 8'd35;
//	candidate[((57+1)*width-1)-:width] <= 8'd10;
//	candidate[((58+1)*width-1)-:width] <= 8'd71;
//	candidate[((59+1)*width-1)-:width] <= 8'd153;
//	candidate[((60+1)*width-1)-:width] <= 8'd179;
//	candidate[((61+1)*width-1)-:width] <= 8'd66;
//	candidate[((62+1)*width-1)-:width] <= 8'd17;
//	candidate[((63+1)*width-1)-:width] <= 8'd169;
//	candidate[((64+1)*width-1)-:width] <= 8'd50;
//	candidate[((65+1)*width-1)-:width] <= 8'd69;
//	candidate[((66+1)*width-1)-:width] <= 8'd35;
//	candidate[((67+1)*width-1)-:width] <= 8'd10;
//	candidate[((68+1)*width-1)-:width] <= 8'd71;
//	candidate[((69+1)*width-1)-:width] <= 8'd153;
//	candidate[((70+1)*width-1)-:width] <= 8'd179;
//	candidate[((71+1)*width-1)-:width] <= 8'd66;
//	candidate[((72+1)*width-1)-:width] <= 8'd17;
//	candidate[((73+1)*width-1)-:width] <= 8'd169;
//	candidate[((74+1)*width-1)-:width] <= 8'd50;
//	candidate[((75+1)*width-1)-:width] <= 8'd69;
//	candidate[((76+1)*width-1)-:width] <= 8'd35;
//	candidate[((77+1)*width-1)-:width] <= 8'd10;
//	candidate[((78+1)*width-1)-:width] <= 8'd71;
//	candidate[((79+1)*width-1)-:width] <= 8'd153;
//	candidate[((80+1)*width-1)-:width] <= 8'd179;
//	candidate[((81+1)*width-1)-:width] <= 8'd66;
//	candidate[((82+1)*width-1)-:width] <= 8'd17;
//	candidate[((83+1)*width-1)-:width] <= 8'd169;
//	candidate[((84+1)*width-1)-:width] <= 8'd50;
//	candidate[((85+1)*width-1)-:width] <= 8'd69;
//	candidate[((86+1)*width-1)-:width] <= 8'd35;
//	candidate[((87+1)*width-1)-:width] <= 8'd10;
//	candidate[((88+1)*width-1)-:width] <= 8'd71;
//	candidate[((89+1)*width-1)-:width] <= 8'd153;
//	candidate[((90+1)*width-1)-:width] <= 8'd179;
//	candidate[((91+1)*width-1)-:width] <= 8'd66;
//	candidate[((92+1)*width-1)-:width] <= 8'd17;
//	candidate[((93+1)*width-1)-:width] <= 8'd169;
//	candidate[((94+1)*width-1)-:width] <= 8'd50;
//	candidate[((95+1)*width-1)-:width] <= 8'd69;
//	candidate[((96+1)*width-1)-:width] <= 8'd35;
//	candidate[((97+1)*width-1)-:width] <= 8'd10;
//	candidate[((98+1)*width-1)-:width] <= 8'd71;
//	candidate[((99+1)*width-1)-:width] <= 8'd153;
//	candidate[((110+1)*width-1)-:width] <= 8'd179;
//	candidate[((111+1)*width-1)-:width] <= 8'd66;
//	candidate[((112+1)*width-1)-:width] <= 8'd17;
//	candidate[((113+1)*width-1)-:width] <= 8'd169;
//	candidate[((114+1)*width-1)-:width] <= 8'd50;
//	candidate[((115+1)*width-1)-:width] <= 8'd69;
//	candidate[((116+1)*width-1)-:width] <= 8'd35;
//	candidate[((117+1)*width-1)-:width] <= 8'd10;
//	candidate[((118+1)*width-1)-:width] <= 8'd71;
//	candidate[((119+1)*width-1)-:width] <= 8'd153;
//	candidate[((120+1)*width-1)-:width] <= 8'd179;
//	candidate[((121+1)*width-1)-:width] <= 8'd66;
//	candidate[((122+1)*width-1)-:width] <= 8'd17;
//	candidate[((123+1)*width-1)-:width] <= 8'd169;
//	candidate[((124+1)*width-1)-:width] <= 8'd50;
//	candidate[((125+1)*width-1)-:width] <= 8'd69;
//	candidate[((126+1)*width-1)-:width] <= 8'd35;
//	candidate[((127+1)*width-1)-:width] <= 8'd10;
//	#100000;  
//	$stop;
//end   