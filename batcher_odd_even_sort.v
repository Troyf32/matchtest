module batcher_odd_even_sort #(parameter quantity = 16,
										 parameter width = 8)
										(input [quantity*width-1:0] candidate,
										 input clk,
										 output reg [quantity*4-1:0]index_sorted);
										 //output reg [quantity*width-1:0] sorted);

integer i;
reg [quantity*width-1:0] OE_2, OE_4_1, OE_4_2, OE_8_1, OE_8_2, OE_8_3, OE_16_1, OE_16_2, OE_16_3, OE_16_4;
reg [quantity*width-1:0] OE_2_D, OE_4_1_D, OE_4_2_D, OE_8_1_D, OE_8_2_D, OE_8_3_D, OE_16_1_D, OE_16_2_D, OE_16_3_D, OE_16_4_D;
reg [width-1:0] temp [9:0];
reg [3:0] index_temp [9:0];
reg [3:0] index9 [quantity-1:0], index8 [quantity-1:0], index7 [quantity-1:0], index6 [quantity-1:0], index5 [quantity-1:0],
			 index4 [quantity-1:0], index3 [quantity-1:0], index2 [quantity-1:0], index1 [quantity-1:0], index0 [quantity-1:0], 
			 index9_D [quantity-1:0], index8_D [quantity-1:0], index7_D [quantity-1:0], index6_D [quantity-1:0], index5_D [quantity-1:0], 
			 index4_D [quantity-1:0], index3_D [quantity-1:0], index2_D [quantity-1:0], index1_D [quantity-1:0], index0_D [quantity-1:0];

always@(posedge clk)
begin
	for(i=0;i<quantity;i=i+1)
		index0_D[i] <= i;
	for(i=0;i<quantity;i=i+1)
		index1_D[i] <= index0[i];
	for(i=0;i<quantity;i=i+1)
		index2_D[i] <= index1[i];
	for(i=0;i<quantity;i=i+1)
		index3_D[i] <= index2[i];
	for(i=0;i<quantity;i=i+1)
		index4_D[i] <= index3[i];
	for(i=0;i<quantity;i=i+1)
		index5_D[i] <= index4[i];
	for(i=0;i<quantity;i=i+1)
		index6_D[i] <= index5[i];
	for(i=0;i<quantity;i=i+1)
		index7_D[i] <= index6[i];
	for(i=0;i<quantity;i=i+1)
		index8_D[i] <= index7[i];
	for(i=0;i<quantity;i=i+1)
		index9_D[i] <= index8[i];
		
	OE_2_D 		<= 	candidate;
	OE_4_1_D 	<= 	OE_2;
	OE_4_2_D		<=		OE_4_1;
	OE_8_1_D		<=		OE_4_2;
	OE_8_2_D		<=		OE_8_1;
	OE_8_3_D		<=		OE_8_2;
	OE_16_1_D	<=		OE_8_3;
	OE_16_2_D	<=		OE_16_1;
	OE_16_3_D	<=		OE_16_2;
	OE_16_4_D	<=		OE_16_3;
	//sorted		<=		OE_16_4;	
	 {index_sorted} <= {index9[15], index9[14], index9[13], index9[12], index9[11], index9[10],
							  index9[9], index9[8], index9[7], index9[6], index9[5], index9[4], index9[3], 
							  index9[2], index9[1], index9[0]};
end

always@(*)
begin
	OE_2 = OE_2_D;
	for(i=0;i<16;i=i+1)
	begin
		{index0[i]} = {index0_D[i]};
	end
	//OE_2
	for(i=0;i<8;i=i+1)
	begin
		if(OE_2[(((2*i+1)*width)-1)-:width] < OE_2[(((2*i+2)*width)-1)-:width])             
		begin
			//swap candidate
			temp[0] = OE_2[(((2*i+2)*width)-1)-:width];
			OE_2[(((2*i+2)*width)-1)-:width] = OE_2[(((2*i+1)*width)-1)-:width];
			OE_2[(((2*i+1)*width)-1)-:width] = temp[0];
			//swap index
			index_temp[0] = index0[2*i];
			index0[2*i] = index0[2*i+1];
			index0[2*i+1] = index_temp[0];
		end
	end
end
always@(*)
begin	
	//OE_4_1
	OE_4_1 = OE_4_1_D;
	for(i=0;i<16;i=i+1)
	begin
		{index1[i]} = {index1_D[i]};
	end
	for(i=0;i<4;i=i+1)
	begin
		if(OE_4_1[(((4*i+1)*width)-1)-:width] < OE_4_1[(((4*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[1] = OE_4_1[(((4*i+3)*width)-1)-:width];
			OE_4_1[(((4*i+3)*width)-1)-:width] = OE_4_1[(((4*i+1)*width)-1)-:width];
			OE_4_1[(((4*i+1)*width)-1)-:width] = temp[1];
			//swap index
			index_temp[1] = index1[4*i];
			index1[4*i] = index1[4*i+2];
			index1[4*i+2] = index_temp[1];
		end
	end
	for(i=0;i<4;i=i+1)
	begin
		if(OE_4_1[(((4*i+2)*width)-1)-:width] < OE_4_1[(((4*i+4)*width)-1)-:width])             
		begin
			//swap candidate
			temp[1] = OE_4_1[(((4*i+4)*width)-1)-:width];
			OE_4_1[(((4*i+4)*width)-1)-:width] = OE_4_1[(((4*i+2)*width)-1)-:width];
			OE_4_1[(((4*i+2)*width)-1)-:width] = temp[1];
			//swap index
			index_temp[1] = index1[4*i+1];
			index1[4*i+1] = index1[4*i+3];
			index1[4*i+3] = index_temp[1];
		end
	end
end
always@(*)
begin
	//OE_4_2
	OE_4_2 = OE_4_2_D;
	for(i=0;i<16;i=i+1)
	begin
		{index2[i]} = {index2_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		if(OE_4_2[(((4*i+2)*width)-1)-:width] < OE_4_2[(((4*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[2] = OE_4_2[(((4*i+3)*width)-1)-:width];
			OE_4_2[(((4*i+3)*width)-1)-:width] = OE_4_2[(((4*i+2)*width)-1)-:width];
			OE_4_2[(((4*i+2)*width)-1)-:width] = temp[2];
			//swap index
			index_temp[2] = index2[4*i+1];
			index2[4*i+1] = index2[4*i+2];
			index2[4*i+2] = index_temp[2];
		end
	end
end
always@(*)
begin
	//OE_8_1
	OE_8_1 = OE_8_1_D;
	for(i=0;i<16;i=i+1)
	begin
		{index3[i]} = {index3_D[i]};
	end
	for(i=0;i<4;i=i+1)
	begin
		if(OE_8_1[(((i+1)*width)-1)-:width] < OE_8_1[(((i+5)*width)-1)-:width])             
		begin
			//swap candidate
			temp[3] = OE_8_1[(((i+5)*width)-1)-:width];
			OE_8_1[(((i+5)*width)-1)-:width] = OE_8_1[(((i+1)*width)-1)-:width];
			OE_8_1[(((i+1)*width)-1)-:width] = temp[3];
			//swap index
			index_temp[3] = index3[i];
			index3[i] = index3[i+4];
			index3[i+4] = index_temp[3];
		end
	end
	for(i=0;i<4;i=i+1)
	begin
		if(OE_8_1[(((i+9)*width)-1)-:width] < OE_8_1[(((i+13)*width)-1)-:width])             
		begin
			//swap candidate
			temp[3] = OE_8_1[(((i+13)*width)-1)-:width];
			OE_8_1[(((i+13)*width)-1)-:width] = OE_8_1[(((i+9)*width)-1)-:width];
			OE_8_1[(((i+9)*width)-1)-:width] = temp[3];
			//swap index
			index_temp[3] = index3[i+8];
			index3[i+8] = index3[i+12];
			index3[i+12] = index_temp[3];
		end
	end
end
always@(*)
begin
	//OE_8_2
	OE_8_2 = OE_8_2_D;
	for(i=0;i<16;i=i+1)
	begin
		{index4[i]} = {index4_D[i]};
	end
	for(i=0;i<2;i=i+1)
	begin
		if(OE_8_2[(((i+3)*width)-1)-:width] < OE_8_2[(((i+5)*width)-1)-:width])             
		begin
			//swap candidate
			temp[4] = OE_8_2[(((i+5)*width)-1)-:width];
			OE_8_2[(((i+5)*width)-1)-:width] = OE_8_2[(((i+3)*width)-1)-:width];
			OE_8_2[(((i+3)*width)-1)-:width] = temp[4];
			//swap index
			index_temp[4] = index4[i+2];
			index4[i+2] = index4[i+4];
			index4[i+4] = index_temp[4];
		end
	end
	for(i=0;i<2;i=i+1)
	begin
		if(OE_8_2[(((i+11)*width)-1)-:width] < OE_8_2[(((i+13)*width)-1)-:width])             
		begin
			//swap candidate
			temp[4] = OE_8_2[(((i+13)*width)-1)-:width];
			OE_8_2[(((i+13)*width)-1)-:width] = OE_8_2[(((i+11)*width)-1)-:width];
			OE_8_2[(((i+11)*width)-1)-:width] = temp[4];
			//swap index
			index_temp[4] = index4[i+10];
			index4[i+10] = index4[i+12];
			index4[i+12] = index_temp[4];
		end
	end
end
always@(*)
begin
	//OE_8_3
	OE_8_3 = OE_8_3_D;
	for(i=0;i<16;i=i+1)
	begin
		{index5[i]} = {index5_D[i]};
	end
	for(i=0;i<3;i=i+1)
	begin
		if(OE_8_3[(((2*i+2)*width)-1)-:width] < OE_8_3[(((2*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[5] = OE_8_3[(((2*i+3)*width)-1)-:width];
			OE_8_3[(((2*i+3)*width)-1)-:width] = OE_8_3[(((2*i+2)*width)-1)-:width];
			OE_8_3[(((2*i+2)*width)-1)-:width] = temp[5];
			//swap index
			index_temp[5] = index5[2*i+1];
			index5[2*i+1] = index5[2*i+2];
			index5[2*i+2] = index_temp[5];
		end
	end
	for(i=0;i<3;i=i+1)
	begin
		if(OE_8_3[(((2*i+10)*width)-1)-:width] < OE_8_3[(((2*i+11)*width)-1)-:width])             
		begin
			//swap candidate
			temp[5] = OE_8_3[(((2*i+11)*width)-1)-:width];
			OE_8_3[(((2*i+11)*width)-1)-:width] = OE_8_3[(((2*i+10)*width)-1)-:width];
			OE_8_3[(((2*i+10)*width)-1)-:width] = temp[5];
			//swap index
			index_temp[5] = index5[2*i+9];
			index5[2*i+9] = index5[2*i+10];
			index5[2*i+10] = index_temp[5];
		end
	end
end
always@(*)
begin
	//OE_16_1
	OE_16_1 = OE_16_1_D;
	for(i=0;i<16;i=i+1)
	begin
		{index6[i]} = {index6_D[i]};
	end
	for(i=0;i<8;i=i+1)
	begin
		if(OE_16_1[(((i+1)*width)-1)-:width] < OE_16_1[(((i+9)*width)-1)-:width])             
		begin
			//swap candidate
			temp[6] = OE_16_1[(((i+9)*width)-1)-:width];
			OE_16_1[(((i+9)*width)-1)-:width] = OE_16_1[(((i+1)*width)-1)-:width];
			OE_16_1[(((i+1)*width)-1)-:width] = temp[6];
			//swap index
			index_temp[6] = index6[i];
			index6[i] = index6[i+8];
			index6[i+8] = index_temp[6];
		end
	end
end
always@(*)
begin
	//OE_16_2
	OE_16_2 = OE_16_2_D;
	for(i=0;i<16;i=i+1)
	begin
		{index7[i]} = {index7_D[i]};
	end
	for(i=0;i<4;i=i+1)
	begin
		if(OE_16_2[(((i+5)*width)-1)-:width] < OE_16_2[(((i+9)*width)-1)-:width])             
		begin
			//swap candidate
			temp[7] = OE_16_2[(((i+9)*width)-1)-:width];
			OE_16_2[(((i+9)*width)-1)-:width] = OE_16_2[(((i+5)*width)-1)-:width];
			OE_16_2[(((i+5)*width)-1)-:width] = temp[7];
			//swap index
			index_temp[7] = index7[i+4];
			index7[i+4] = index7[i+8];
			index7[i+8] = index_temp[7];
		end
	end
end
always@(*)
begin
	//OE_16_3
	OE_16_3 = OE_16_3_D;
	for(i=0;i<16;i=i+1)
	begin
		{index8[i]} = {index8_D[i]};
	end
	for(i=0;i<2;i=i+1)
	begin
		if(OE_16_3[(((i+3)*width)-1)-:width] < OE_16_3[(((i+5)*width)-1)-:width])             
		begin
			//swap candidate
			temp[8] = OE_16_3[(((i+5)*width)-1)-:width];
			OE_16_3[(((i+5)*width)-1)-:width] = OE_16_3[(((i+3)*width)-1)-:width];
			OE_16_3[(((i+3)*width)-1)-:width] = temp[8];
			//swap index
			index_temp[8] = index8[i+2];
			index8[i+2] = index8[i+4];
			index8[i+4] = index_temp[8];
		end
	end
	for(i=0;i<2;i=i+1)
	begin
		if(OE_16_3[(((i+7)*width)-1)-:width] < OE_16_3[(((i+9)*width)-1)-:width])             
		begin
			//swap candidate
			temp[8] = OE_16_3[(((i+9)*width)-1)-:width];
			OE_16_3[(((i+9)*width)-1)-:width] = OE_16_3[(((i+7)*width)-1)-:width];
			OE_16_3[(((i+7)*width)-1)-:width] = temp[8];
			//swap index
			index_temp[8] = index8[i+6];
			index8[i+6] = index8[i+8];
			index8[i+8] = index_temp[8];
		end
	end
	for(i=0;i<2;i=i+1)
	begin
		if(OE_16_3[(((i+11)*width)-1)-:width] < OE_16_3[(((i+13)*width)-1)-:width])             
		begin
			//swap candidate
			temp[8] = OE_16_3[(((i+13)*width)-1)-:width];
			OE_16_3[(((i+13)*width)-1)-:width] = OE_16_3[(((i+11)*width)-1)-:width];
			OE_16_3[(((i+11)*width)-1)-:width] = temp[8];
			//swap index
			index_temp[8] = index8[i+10];
			index8[i+10] = index8[i+12];
			index8[i+12] = index_temp[8];
		end
	end
end
always@(*)
begin
	//OE_16_4
	OE_16_4 = OE_16_4_D;
	for(i=0;i<16;i=i+1)
	begin
		{index9[i]} = {index9_D[i]};
	end
	for(i=0;i<7;i=i+1)
	begin
		if(OE_16_4[(((2*i+2)*width)-1)-:width] < OE_16_4[(((2*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[9] = OE_16_4[(((2*i+3)*width)-1)-:width];
			OE_16_4[(((2*i+3)*width)-1)-:width] = OE_16_4[(((2*i+2)*width)-1)-:width];
			OE_16_4[(((2*i+2)*width)-1)-:width] = temp[9];
			//swap index
			index_temp[9] = index9[2*i+1];
			index9[2*i+1] = index9[2*i+2];
			index9[2*i+2] = index_temp[9];
		end
	end
end

endmodule

//module batcher_odd_even_sort #(parameter quantity = 16,
//										 parameter width = 8)
//										(input [quantity*width-1:0] candidate,
//										 input clk,
//										 output reg [quantity*4-1:0]index_sorted,
//										 output reg [quantity*width-1:0] sorted);
//
//integer i;
//reg [quantity*width-1:0] OE_2, OE_4_1, OE_4_2, OE_8_1, OE_8_2, OE_8_3, OE_16_1, OE_16_2, OE_16_3, OE_16_4;
//reg [width-1:0] temp [9:0];
////wire [quantity*width-1:0] OE_2_line, OE_4_1_line, OE_4_2_line, OE_8_1_line, OE_8_2_line, 
//								// OE_8_3_line, OE_16_1_line, OE_16_2_line, OE_16_3_line, OE_16_4_line;
//reg [3:0] index9 [quantity-1:0], index8 [quantity-1:0], index7 [quantity-1:0], index6 [quantity-1:0], index5 [quantity-1:0], 
//			 index4 [quantity-1:0], index3 [quantity-1:0], index2 [quantity-1:0], index1 [quantity-1:0], index0 [quantity-1:0];
//reg [quantity*width-1:0] candidate_q;
//wire candidate_trigger;
//
////wire [quantity*width-1:0] OE_2_line, OE_4_1_line, OE_4_2_line, OE_8_1_line, OE_8_2_line, OE_8_3_line, OE_16_1_line, OE_16_2_line, OE_16_3_line, OE_16_4_line;
////
////assign OE_2_line = candidate;
////assign OE_4_1_line = OE_2;
////assign OE_4_2_line = OE_4_1;
////assign OE_8_1_line = OE_4_2;
////assign OE_8_2_line = OE_8_1;
////assign OE_8_3_line = OE_8_2;
////assign OE_16_1_line = OE_8_3;
////assign OE_16_2_line = OE_16_1;
////assign OE_16_3_line = OE_16_2;
////assign OE_16_4_line = OE_16_3;
////assign sorted = OE_16_4;
//
//
//always@(posedge clk)
//begin
//	candidate_q <= candidate;
//end
//
//assign candidate_trigger = |(candidate_q!=candidate);
//
//always@(posedge clk)
//begin
//	if(candidate_trigger)
//	begin
//	OE_2 <= candidate;
//		for(i=0;i<quantity;i=i+1)
//			index0[i] <= i;
//	end
//	else
//	for(i=0;i<16;i=i+1)
//	begin
//		{index1[i]} <= {index0[i]};
//		{index2[i]} <= {index1[i]};
//		{index3[i]} <= {index2[i]};
//		{index4[i]} <= {index3[i]};
//		{index5[i]} <= {index4[i]};
//		{index6[i]} <= {index5[i]};
//		{index7[i]} <= {index6[i]};
//		{index8[i]} <= {index7[i]};
//		{index9[i]} <= {index8[i]};
//	end                     
//	{index_sorted}<= {index9[15], index9[14], index9[13], index9[12], index9[11], index9[10],
//							index9[9], index9[8], index9[7], index9[6], index9[5], index9[4], index9[3], 
//							index9[2], index9[1], index9[0]};
//	
//	OE_4_1 <= OE_2;
//	OE_4_2 <= OE_4_1;
//	OE_8_1 <= OE_4_2;
//	OE_8_2 <= OE_8_1;
//	OE_8_3 <= OE_8_2;
//	OE_16_1 <= OE_8_3;
//	OE_16_2 <= OE_16_1;
//	OE_16_3 <= OE_16_2;
//	OE_16_4 <= OE_16_3;
//	sorted <= OE_16_4;
//	for(i=0;i<16;i=i+1)
//	begin
//		if()
//	end
//	
//	//OE_2
//	for(i=0;i<8;i=i+1)
//	begin
//		if(OE_2[(((2*i+1)*width)-1)-:width] < OE_2[(((2*i+2)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_2[(((2*i+2)*width)-1)-:width] <= OE_2[(((2*i+1)*width)-1)-:width];
//			OE_2[(((2*i+1)*width)-1)-:width] <= OE_2[(((2*i+2)*width)-1)-:width];
//			//swap index
//			index0[2*i] <= index0[2*i+1];
//			index0[2*i+1] <= index0[2*i];
//		end
//	end
//	//OE_4_1
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_4_1[(((4*i+1)*width)-1)-:width] < OE_4_1[(((4*i+3)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_4_1[(((4*i+3)*width)-1)-:width] <= OE_4_1[(((4*i+1)*width)-1)-:width];
//			OE_4_1[(((4*i+1)*width)-1)-:width] <= OE_4_1[(((4*i+3)*width)-1)-:width];
//			//swap index
//			index1[4*i] <= index1[4*i+2];
//			index1[4*i+2] <= index1[4*i];
//		end
//	end
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_4_1[(((4*i+2)*width)-1)-:width] < OE_4_1[(((4*i+4)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_4_1[(((4*i+4)*width)-1)-:width] <= OE_4_1[(((4*i+2)*width)-1)-:width];
//			OE_4_1[(((4*i+2)*width)-1)-:width] <= OE_4_1[(((4*i+4)*width)-1)-:width];
//			//swap index
//			index1[4*i+1] <= index1[4*i+3];
//			index1[4*i+3] <= index1[4*i+1];
//		end
//	end
//	//OE_4_2
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_4_2[(((4*i+2)*width)-1)-:width] < OE_4_2[(((4*i+3)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_4_2[(((4*i+3)*width)-1)-:width] <= OE_4_2[(((4*i+2)*width)-1)-:width];
//			OE_4_2[(((4*i+2)*width)-1)-:width] <= OE_4_2[(((4*i+3)*width)-1)-:width];
//			//swap index
//			index2[4*i+1] <= index2[4*i+2];
//			index2[4*i+2] <= index2[4*i+1];
//		end
//	end
//	//OE_8_1
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_8_1[(((i+1)*width)-1)-:width] < OE_8_1[(((i+5)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_1[(((i+5)*width)-1)-:width] <= OE_8_1[(((i+1)*width)-1)-:width];
//			OE_8_1[(((i+1)*width)-1)-:width] <= OE_8_1[(((i+5)*width)-1)-:width];
//			//swap index
//			index3[i] <= index3[i+4];
//			index3[i+4] <= index3[i];
//		end
//	end
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_8_1[(((i+9)*width)-1)-:width] < OE_8_1[(((i+13)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_1[(((i+13)*width)-1)-:width] <= OE_8_1[(((i+9)*width)-1)-:width];
//			OE_8_1[(((i+9)*width)-1)-:width] <= OE_8_1[(((i+13)*width)-1)-:width];
//			//swap index
//			index3[i+8] <= index3[i+12];
//			index3[i+12] <= index3[i+8];
//		end
//	end
//	//OE_8_2
//	for(i=0;i<2;i=i+1)
//	begin
//		if(OE_8_2[(((i+3)*width)-1)-:width] < OE_8_2[(((i+5)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_2[(((i+5)*width)-1)-:width] <= OE_8_2[(((i+3)*width)-1)-:width];
//			OE_8_2[(((i+3)*width)-1)-:width] <= OE_8_2[(((i+5)*width)-1)-:width];
//			//swap index
//			index4[i+2] <= index4[i+4];
//			index4[i+4] <= index4[i+2];
//		end
//	end
//	for(i=0;i<2;i=i+1)
//	begin
//		if(OE_8_2[(((i+9)*width)-1)-:width] < OE_8_2[(((i+13)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_2[(((i+13)*width)-1)-:width] <= OE_8_2[(((i+9)*width)-1)-:width];
//			OE_8_2[(((i+9)*width)-1)-:width] <= OE_8_2[(((i+13)*width)-1)-:width];
//			//swap index
//			index4[i+10] <= index4[i+12];
//			index4[i+12] <= index4[i+10];
//		end
//	end
//	//OE_8_3
//	for(i=0;i<3;i=i+1)
//	begin
//		if(OE_8_2[(((2*i+2)*width)-1)-:width] < OE_8_2[(((2*i+3)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_2[(((2*i+3)*width)-1)-:width] <= OE_8_2[(((2*i+2)*width)-1)-:width];
//			OE_8_2[(((2*i+2)*width)-1)-:width] <= OE_8_2[(((2*i+3)*width)-1)-:width];
//			//swap index
//			index5[2*i+1] <= index5[2*i+2];
//			index5[2*i+2] <= index5[2*i+1];
//		end
//	end
//	for(i=0;i<3;i=i+1)
//	begin
//		if(OE_8_3[(((2*i+10)*width)-1)-:width] < OE_8_3[(((2*i+11)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_8_3[(((2*i+11)*width)-1)-:width] <= OE_8_3[(((2*i+11)*width)-1)-:width];
//			OE_8_3[(((2*i+10)*width)-1)-:width] <= OE_8_3[(((2*i+10)*width)-1)-:width];
//			//swap index
//			index5[2*i+9] <= index5[2*i+10];
//			index5[2*i+10] <= index5[2*i+9];
//		end
//	end
//	//OE_16_1
//	for(i=0;i<8;i=i+1)
//	begin
//		if(OE_16_1[(((i+1)*width)-1)-:width] < OE_16_1[(((i+9)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_1[(((i+9)*width)-1)-:width] <= OE_16_1[(((i+1)*width)-1)-:width];
//			OE_16_1[(((i+1)*width)-1)-:width] <= OE_16_1[(((i+9)*width)-1)-:width];
//			//swap index
//			index6[i] <= index6[i+8];
//			index6[i+8] <= index6[i];
//		end
//	end
//	//OE_16_2
//	for(i=0;i<4;i=i+1)
//	begin
//		if(OE_16_2[(((i+5)*width)-1)-:width] < OE_16_2[(((i+8)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_2[(((i+8)*width)-1)-:width] <= OE_16_2[(((i+5)*width)-1)-:width];
//			OE_16_2[(((i+5)*width)-1)-:width] <= OE_16_2[(((i+8)*width)-1)-:width];
//			//swap index
//			index7[i+4] <= index7[i+8];
//			index7[i+8] <= index7[i+4];
//		end
//	end
//	//OE_16_3
//	for(i=0;i<2;i=i+1)
//	begin
//		if(OE_16_3[(((i+3)*width)-1)-:width] < OE_16_3[(((i+5)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_3[(((i+5)*width)-1)-:width] <= OE_16_3[(((i+3)*width)-1)-:width];
//			OE_16_3[(((i+3)*width)-1)-:width] <= OE_16_3[(((i+5)*width)-1)-:width];
//			//swap index
//			index8[i+2] <= index8[i+4];
//			index8[i+4] <= index8[i+2];
//		end
//	end
//	for(i=0;i<2;i=i+1)
//	begin
//		if(OE_16_3[(((i+7)*width)-1)-:width] < OE_16_3[(((i+9)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_3[(((i+9)*width)-1)-:width] <= OE_16_3[(((i+7)*width)-1)-:width];
//			OE_16_3[(((i+7)*width)-1)-:width] <= OE_16_3[(((i+9)*width)-1)-:width];
//			//swap index
//			index8[i+6] <= index8[i+8];
//			index8[i+8] <= index8[i+6];
//		end
//	end
//	for(i=0;i<2;i=i+1)
//	begin
//		if(OE_16_3[(((i+11)*width)-1)-:width] < OE_16_3[(((i+13)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_3[(((i+13)*width)-1)-:width] <= OE_16_3[(((i+11)*width)-1)-:width];
//			OE_16_3[(((i+11)*width)-1)-:width] <= OE_16_3[(((i+13)*width)-1)-:width];
//			//swap index
//			index8[i+10] <= index8[i+12];
//			index8[i+12] <= index8[i+10];
//		end
//	end
//	//OE_16_4
//	for(i=0;i<7;i=i+1)
//	begin
//		if(OE_16_4[(((2*i+2)*width)-1)-:width] < OE_16_4[(((2*i+3)*width)-1)-:width])             
//		begin
//			//swap candidate
//			OE_16_4[(((2*i+3)*width)-1)-:width] <= OE_16_4[(((2*i+2)*width)-1)-:width];
//			OE_16_4[(((2*i+2)*width)-1)-:width] <= OE_16_4[(((2*i+3)*width)-1)-:width];
//			//swap index
//			index9[2*i+1] <= index9[2*i+2];
//			index9[2*i+2] <= index9[2*i+1];
//		end
//	end
//end
//
//endmodule