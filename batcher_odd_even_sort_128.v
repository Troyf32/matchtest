module batcher_odd_even_sort_128  #(parameter quantity = 128,
											   parameter width = 8)
											  (input [quantity*width-1:0] candidate,
											   input clk,
											   output reg [quantity*7-1:0]index_sorted,
											   output reg [quantity*width-1:0] sorted);

integer i, j, k;
reg [quantity*width-1:0] OE_2, OE_4_1, OE_4_2, OE_8_1, OE_8_2, OE_8_3, OE_16_1, OE_16_2, OE_16_3, OE_16_4, OE_32_1, OE_32_2, OE_32_3, OE_32_4, OE_32_5,
								 OE_64_1, OE_64_2, OE_64_3, OE_64_4, OE_64_5, OE_64_6, OE_128_1, OE_128_2, OE_128_3, OE_128_4, OE_128_5, OE_128_6, OE_128_7;
reg [quantity*width-1:0] OE_2_D, OE_4_1_D, OE_4_2_D, OE_8_1_D, OE_8_2_D, OE_8_3_D, OE_16_1_D, OE_16_2_D, OE_16_3_D, OE_16_4_D, OE_32_1_D, OE_32_2_D, OE_32_3_D, OE_32_4_D, OE_32_5_D,
								 OE_64_1_D, OE_64_2_D, OE_64_3_D, OE_64_4_D, OE_64_5_D, OE_64_6_D, OE_128_1_D, OE_128_2_D, OE_128_3_D, OE_128_4_D, OE_128_5_D, OE_128_6_D, OE_128_7_D;
reg [width-1:0] temp [27:0];
reg [6:0] index_temp [27:0];
reg [6:0] index27 [quantity-1:0], index26 [quantity-1:0], index25 [quantity-1:0],
			 index24 [quantity-1:0], index23 [quantity-1:0], index22 [quantity-1:0], index21 [quantity-1:0], index20 [quantity-1:0],
			 index19 [quantity-1:0], index18 [quantity-1:0], index17 [quantity-1:0], index16 [quantity-1:0], index15 [quantity-1:0],
			 index14 [quantity-1:0], index13 [quantity-1:0], index12 [quantity-1:0], index11 [quantity-1:0], index10 [quantity-1:0],
			 index9 [quantity-1:0], index8 [quantity-1:0], index7 [quantity-1:0], index6 [quantity-1:0], index5 [quantity-1:0],
			 index4 [quantity-1:0], index3 [quantity-1:0], index2 [quantity-1:0], index1 [quantity-1:0], index0 [quantity-1:0], 
			 index27_D [quantity-1:0], index26_D [quantity-1:0], index25_D [quantity-1:0],
			 index24_D [quantity-1:0], index23_D [quantity-1:0], index22_D [quantity-1:0], index21_D [quantity-1:0], index20_D [quantity-1:0],
			 index19_D [quantity-1:0], index18_D [quantity-1:0], index17_D [quantity-1:0], index16_D [quantity-1:0], index15_D [quantity-1:0],
			 index14_D [quantity-1:0], index13_D [quantity-1:0], index12_D [quantity-1:0], index11_D [quantity-1:0], index10_D [quantity-1:0],
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
	for(i=0;i<quantity;i=i+1)
		index10_D[i] <= index9[i];
	for(i=0;i<quantity;i=i+1)
		index11_D[i] <= index10[i];
	for(i=0;i<quantity;i=i+1)
		index12_D[i] <= index11[i];
	for(i=0;i<quantity;i=i+1)
		index13_D[i] <= index12[i];
	for(i=0;i<quantity;i=i+1)
		index14_D[i] <= index13[i];
	for(i=0;i<quantity;i=i+1)
		index15_D[i] <= index14[i];
	for(i=0;i<quantity;i=i+1)
		index16_D[i] <= index15[i];
	for(i=0;i<quantity;i=i+1)
		index17_D[i] <= index16[i];
	for(i=0;i<quantity;i=i+1)
		index18_D[i] <= index17[i];
	for(i=0;i<quantity;i=i+1)
		index19_D[i] <= index18[i];
	for(i=0;i<quantity;i=i+1)
		index20_D[i] <= index19[i];
	for(i=0;i<quantity;i=i+1)
		index21_D[i] <= index20[i];
	for(i=0;i<quantity;i=i+1)
		index22_D[i] <= index21[i];
	for(i=0;i<quantity;i=i+1)
		index23_D[i] <= index22[i];
	for(i=0;i<quantity;i=i+1)
		index24_D[i] <= index23[i];
	for(i=0;i<quantity;i=i+1)
		index25_D[i] <= index24[i];
	for(i=0;i<quantity;i=i+1)
		index26_D[i] <= index25[i];
	for(i=0;i<quantity;i=i+1)
		index27_D[i] <= index26[i];

		
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
	OE_32_1_D	<=		OE_16_4;
	OE_32_2_D	<=		OE_32_1;
	OE_32_3_D	<=		OE_32_2;
	OE_32_4_D	<=		OE_32_3;
	OE_32_5_D	<=		OE_32_4;
	OE_64_1_D	<=		OE_32_5;
	OE_64_2_D	<=		OE_64_1;
	OE_64_3_D	<=		OE_64_2;
	OE_64_4_D	<=		OE_64_3;
	OE_64_5_D	<=		OE_64_4;
	OE_64_6_D	<=		OE_64_5;
	OE_128_1_D	<=		OE_64_6;
	OE_128_2_D	<=		OE_128_1;
	OE_128_3_D	<=		OE_128_2;
	OE_128_4_D	<=		OE_128_3;
	OE_128_5_D	<=		OE_128_4;
	OE_128_6_D	<=		OE_128_5;
	OE_128_7_D	<=		OE_128_6;
	sorted		<= 	OE_128_7;
	
	 {index_sorted} <= {index27[127], index27[126], index27[125],
							  index27[124], index27[123], index27[122], index27[121], index27[120],
							  index27[119], index27[118], index27[117], index27[116], index27[115],
							  index27[114], index27[113], index27[112], index27[111], index27[110],
							  index27[109], index27[108], index27[107], index27[106], index27[105],
							  index27[104], index27[103], index27[102], index27[101], index27[100],
							  index27[99],  index27[98],  index27[97],  index27[96],  index27[95],
							  index27[94],  index27[93],  index27[92],  index27[91],  index27[90],
							  index27[89],  index27[88],  index27[87],  index27[86],  index27[85],
							  index27[84],  index27[83],  index27[82],  index27[81],  index27[80],
							  index27[79],  index27[78],  index27[77],  index27[76],  index27[75],
							  index27[74],  index27[73],  index27[72],  index27[71],  index27[70],
							  index27[69],  index27[68],  index27[67],  index27[66],  index27[65],
							  index27[64],  index27[63],  index27[62],  index27[61],  index27[60],
							  index27[59],  index27[58],  index27[57],  index27[56],  index27[55],
							  index27[54],  index27[53],  index27[52],  index27[51],  index27[50],
							  index27[49],  index27[48],  index27[47],  index27[46],  index27[45],
							  index27[44],  index27[43],  index27[42],  index27[41],  index27[40],
							  index27[39],  index27[38],  index27[37],  index27[36],  index27[35],
							  index27[34],  index27[33],  index27[32],  index27[31],  index27[30],
							  index27[29],  index27[28],  index27[27],  index27[26],  index27[25],
							  index27[24],  index27[23],  index27[22],  index27[21],  index27[20],
							  index27[19],  index27[18],  index27[17],  index27[16],  index27[15],
							  index27[14],  index27[13],  index27[12],  index27[11],  index27[10], 
							  index27[9], 	 index27[8], 	index27[7],   index27[6], 	 index27[5], 
							  index27[4], 	 index27[3], 	index27[2],   index27[1], 	 index27[0]};
							 
end

always@(*)
begin
	//OE_2
	OE_2 = OE_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index0[i]} = {index0_D[i]};
	end
	for(i=0;i<64;i=i+1)
	begin
		if(OE_2[(((2*i+1)*width)-1)-:width] < OE_2[(((2*i+2)*width)-1)-:width])             
		begin
			//swap candidate
			temp[0] = OE_2[(((2*i+2)*width)-1)-:width];
			OE_2[(((2*i+2)*width)-1)-:width] = OE_2[(((2*i+1)*width)-1)-:width];
			OE_2[(((2*i+1)*width)-1)-:width] = temp[0];
			//swap index
			index_temp[0] = index0[2*i+1];
			index0[2*i+1] = index0[2*i];
			index0[2*i] = index_temp[0];
		end
	end
end
always@(*)
begin	
	//OE_4_1
	OE_4_1 = OE_4_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index1[i]} = {index1_D[i]};
	end
	for(i=0;i<32;i=i+1)
	begin
		for(j=0;j<2;j=j+1)
		begin
			if(OE_4_1[(((4*i+j+1)*width)-1)-:width] < OE_4_1[(((4*i+j+3)*width)-1)-:width])             
			begin
				//swap candidate
				temp[1] = OE_4_1[(((4*i+j+3)*width)-1)-:width];
				OE_4_1[(((4*i+j+3)*width)-1)-:width] = OE_4_1[(((4*i+j+1)*width)-1)-:width];
				OE_4_1[(((4*i+j+1)*width)-1)-:width] = temp[1];
				//swap index
				index_temp[1] = index1[4*i+j+2];
				index1[4*i+j+2] = index1[4*i+j];
				index1[4*i+j] = index_temp[1];
			end
		end
	end
end
always@(*)
begin
	//OE_4_2
	OE_4_2 = OE_4_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index2[i]} = {index2_D[i]};
	end 
	for(i=0;i<32;i=i+1)
	begin
		if(OE_4_2[(((4*i+2)*width)-1)-:width] < OE_4_2[(((4*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[2] = OE_4_2[(((4*i+3)*width)-1)-:width];
			OE_4_2[(((4*i+3)*width)-1)-:width] = OE_4_2[(((4*i+2)*width)-1)-:width];
			OE_4_2[(((4*i+2)*width)-1)-:width] = temp[2];
			//swap index
			index_temp[2] = index2[4*i+2];
			index2[4*i+2] = index2[4*i+1];
			index2[4*i+1] = index_temp[2];
		end
	end
end
always@(*)
begin
	//OE_8_1
	OE_8_1 = OE_8_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index3[i]} = {index3_D[i]};
	end
	for(i=0;i<16;i=i+1)
	begin
		for(j=0;j<4;j=j+1)
		begin
			if(OE_8_1[(((8*i+j+1)*width)-1)-:width] < OE_8_1[(((8*i+j+5)*width)-1)-:width])             
			begin
				//swap candidate
				temp[3] = OE_8_1[(((8*i+j+5)*width)-1)-:width];
				OE_8_1[(((8*i+j+5)*width)-1)-:width] = OE_8_1[(((8*i+j+1)*width)-1)-:width];
				OE_8_1[(((8*i+j+1)*width)-1)-:width] = temp[3];
				//swap index
				index_temp[3] = index3[8*i+j+4];
				index3[8*i+j+4] = index3[8*i+j];
				index3[8*i+j] = index_temp[3];
			end
		end
	end
end
always@(*)
begin
	//OE_8_2
	OE_8_2 = OE_8_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index4[i]} = {index4_D[i]};
	end
	for(i=0;i<16;i=i+1)
	begin
		for(j=0;j<2;j=j+1)
		begin
			if(OE_8_2[(((8*i+j+3)*width)-1)-:width] < OE_8_2[(((8*i+j+5)*width)-1)-:width])             
			begin
				//swap candidate
				temp[4] = OE_8_2[(((8*i+j+5)*width)-1)-:width];
				OE_8_2[(((8*i+j+5)*width)-1)-:width] = OE_8_2[(((8*i+j+3)*width)-1)-:width];
				OE_8_2[(((8*i+j+3)*width)-1)-:width] = temp[4];
				//swap index
				index_temp[4] = index4[8*i+j+4];
				index4[8*i+j+4] = index4[8*i+j+2];
				index4[8*i+j+2] = index_temp[4];
			end
		end
	end
end
always@(*)
begin
	//OE_8_3
	OE_8_3 = OE_8_3_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index5[i]} = {index5_D[i]};
	end
	for(i=0;i<16;i=i+1)
	begin
		for(j=0;j<3;j=j+1)
		begin
			if(OE_8_3[(((8*i+2*j+2)*width)-1)-:width] < OE_8_3[(((8*i+2*j+3)*width)-1)-:width])             
			begin
				//swap candidate
				temp[5] = OE_8_3[(((8*i+2*j+3)*width)-1)-:width];
				OE_8_3[(((8*i+2*j+3)*width)-1)-:width] = OE_8_3[(((8*i+2*j+2)*width)-1)-:width];
				OE_8_3[(((8*i+2*j+2)*width)-1)-:width] = temp[5];
				//swap index
				index_temp[5] = index5[8*i+2*j+2];
				index5[8*i+2*j+2] = index5[8*i+2*j+1];
				index5[8*i+2*j+1] = index_temp[5];
			end
		end
	end
end
always@(*)
begin
	//OE_16_1
	OE_16_1 = OE_16_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index6[i]} = {index6_D[i]};
	end
	for(i=0;i<8;i=i+1)
	begin
		for(j=0;j<8;j=j+1)
		begin
			if(OE_16_1[(((16*i+j+1)*width)-1)-:width] < OE_16_1[(((16*i+j+9)*width)-1)-:width])             
			begin
				//swap candidate
				temp[6] = OE_16_1[(((16*i+j+9)*width)-1)-:width];
				OE_16_1[(((16*i+j+9)*width)-1)-:width] = OE_16_1[(((16*i+j+1)*width)-1)-:width];
				OE_16_1[(((16*i+j+1)*width)-1)-:width] = temp[6];
				//swap index
				index_temp[6] = index6[16*i+j+8];
				index6[16*i+j+8] = index6[16*i+j];
				index6[16*i+j] = index_temp[6];
			end
		end
	end
end
always@(*)
begin
	//OE_16_2
	OE_16_2 = OE_16_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index7[i]} = {index7_D[i]};
	end
	for(i=0;i<8;i=i+1)
	begin
		for(j=0;j<4;j=j+1)
		begin
			if(OE_16_2[(((16*i+j+5)*width)-1)-:width] < OE_16_2[(((16*i+j+9)*width)-1)-:width])             
			begin
				//swap candidate
				temp[7] = OE_16_2[(((16*i+j+9)*width)-1)-:width];
				OE_16_2[(((16*i+j+9)*width)-1)-:width] = OE_16_2[(((16*i+j+5)*width)-1)-:width];
				OE_16_2[(((16*i+j+5)*width)-1)-:width] = temp[7];
				//swap index
				index_temp[7] = index7[16*i+j+8];
				index7[16*i+j+8] = index7[16*i+j+4];
				index7[16*i+j+4] = index_temp[7];
			end
		end
	end
end
always@(*)
begin
	//OE_16_3
	OE_16_3 = OE_16_3_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index8[i]} = {index8_D[i]};
	end
	for(i=0;i<8;i=i+1)
	begin
		for(j=0;j<3;j=j+1)
		begin
			for(k=0;k<2;k=k+1)
			begin
				if(OE_16_3[(((16*i+4*j+k+3)*width)-1)-:width] < OE_16_3[(((16*i+4*j+k+5)*width)-1)-:width])             
				begin
					//swap candidate
					temp[8] = OE_16_3[(((16*i+4*j+k+5)*width)-1)-:width];
					OE_16_3[(((16*i+4*j+k+5)*width)-1)-:width] = OE_16_3[(((16*i+4*j+k+3)*width)-1)-:width];
					OE_16_3[(((16*i+4*j+k+3)*width)-1)-:width] = temp[8];
					//swap index
					index_temp[8] = index8[16*i+4*j+k+4];
					index8[16*i+4*j+k+4] = index8[16*i+4*j+k+2];
					index8[16*i+4*j+k+2] = index_temp[8];
				end
			end
		end
	end
end
always@(*)
begin
	//OE_16_4
	OE_16_4 = OE_16_4_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index9[i]} = {index9_D[i]};
	end
	for(i=0;i<8;i=i+1)
	begin
		for(j=0;j<7;j=j+1)
		begin
			if(OE_16_4[(((16*i+2*j+2)*width)-1)-:width] < OE_16_4[(((16*i+2*j+3)*width)-1)-:width])             
			begin
				//swap candidate
				temp[9] = OE_16_4[(((16*i+2*j+3)*width)-1)-:width];
				OE_16_4[(((16*i+2*j+3)*width)-1)-:width] = OE_16_4[(((16*i+2*j+2)*width)-1)-:width];
				OE_16_4[(((16*i+2*j+2)*width)-1)-:width] = temp[9];
				//swap index
				index_temp[9] = index9[16*i+2*j+2];
				index9[16*i+2*j+2] = index9[16*i+2*j+1];
				index9[16*i+2*j+1] = index_temp[9];
			end
		end
	end
end
always@(*)
begin
	//OE_32_1
	OE_32_1 = OE_32_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index10[i]} = {index10_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		for(j=0;j<16;j=j+1)
		begin
			if(OE_32_1[(((32*i+j+1)*width)-1)-:width] < OE_32_1[(((32*i+j+17)*width)-1)-:width])             
			begin
				//swap candidate
				temp[10] = OE_32_1[(((32*i+j+17)*width)-1)-:width];
				OE_32_1[(((32*i+j+17)*width)-1)-:width] = OE_32_1[(((32*i+j+1)*width)-1)-:width];
				OE_32_1[(((32*i+j+1)*width)-1)-:width] = temp[10];
				//swap index
				index_temp[10] = index10[32*i+j+16];
				index10[32*i+j+16] = index10[32*i+j];
				index10[32*i+j] = index_temp[10];
			end
		end
	end
end
always@(*)
begin
	//OE_32_2
	OE_32_2 = OE_32_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index11[i]} = {index11_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		for(j=0;j<8;j=j+1)
		begin
			if(OE_32_2[(((32*i+j+9)*width)-1)-:width] < OE_32_2[(((32*i+j+17)*width)-1)-:width])             
			begin
				//swap candidate
				temp[11] = OE_32_2[(((32*i+j+17)*width)-1)-:width];
				OE_32_2[(((32*i+j+17)*width)-1)-:width] = OE_32_2[(((32*i+j+9)*width)-1)-:width];
				OE_32_2[(((32*i+j+9)*width)-1)-:width] = temp[11];
				//swap index
				index_temp[11] = index11[32*i+j+16];
				index11[32*i+j+16] = index11[32*i+j+8];
				index11[32*i+j+8] = index_temp[11];
			end
		end
	end
end
always@(*)
begin
	//OE_32_3
	OE_32_3 = OE_32_3_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index12[i]} = {index12_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		for(j=0;j<3;j=j+1)
		begin
			for(k=0;k<4;k=k+1)
			if(OE_32_3[(((32*i+8*j+k+5)*width)-1)-:width] < OE_32_3[(((32*i+8*j+k+9)*width)-1)-:width])             
			begin
				//swap candidate
				temp[12] = OE_32_3[(((32*i+8*j+k+9)*width)-1)-:width];
				OE_32_3[(((32*i+8*j+k+9)*width)-1)-:width] = OE_32_3[(((32*i+8*j+k+5)*width)-1)-:width];
				OE_32_3[(((32*i+8*j+k+5)*width)-1)-:width] = temp[12];
				//swap index
				index_temp[12] = index12[32*i+8*j+k+8];
				index12[32*i+8*j+k+8] = index12[32*i+8*j+k+4];
				index12[32*i+8*j+k+4] = index_temp[12];
			end
		end
	end
end
always@(*)
begin
	//OE_32_4
	OE_32_4 = OE_32_4_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index13[i]} = {index13_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		for(j=0;j<7;j=j+1)
		begin
			for(k=0;k<2;k=k+1)
			begin
				if(OE_32_4[(((32*i+4*j+k+3)*width)-1)-:width] < OE_32_4[(((32*i+4*j+k+5)*width)-1)-:width])             
				begin
					//swap candidate
					temp[13] = OE_32_4[(((32*i+4*j+k+5)*width)-1)-:width];
					OE_32_4[(((32*i+4*j+k+5)*width)-1)-:width] = OE_32_4[(((32*i+4*j+k+3)*width)-1)-:width];
					OE_32_4[(((32*i+4*j+k+3)*width)-1)-:width] = temp[13];
					//swap index
					index_temp[13] = index13[32*i+4*j+k+4];
					index13[32*i+4*j+k+4] = index13[32*i+4*j+k+2];
					index13[32*i+4*j+k+2] = index_temp[13];
				end
			end
		end
	end
end
always@(*)
begin
	//OE_32_5
	OE_32_5 = OE_32_5_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index14[i]} = {index14_D[i]};
	end 
	for(i=0;i<4;i=i+1)
	begin
		for(j=0;j<15;j=j+1)
		begin
			if(OE_32_5[(((32*i+2*j+2)*width)-1)-:width] < OE_32_5[(((32*i+2*j+3)*width)-1)-:width])             
			begin
				//swap candidate
				temp[14] = OE_32_5[(((32*i+2*j+3)*width)-1)-:width];
				OE_32_5[(((32*i+2*j+3)*width)-1)-:width] = OE_32_5[(((32*i+2*j+2)*width)-1)-:width];
				OE_32_5[(((32*i+2*j+2)*width)-1)-:width] = temp[14];
				//swap index
				index_temp[14] = index14[32*i+2*j+2];
				index14[32*i+2*j+2] = index14[32*i+2*j+1];
				index14[32*i+2*j+1] = index_temp[14];
			end
		end
	end
end
always@(*)
begin
	//OE_64_1
	OE_64_1 = OE_64_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index15[i]} = {index15_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<32;j=j+1)
		begin
			if(OE_64_1[(((64*i+j+1)*width)-1)-:width] < OE_64_1[(((64*i+j+33)*width)-1)-:width])             
			begin
				//swap candidate
				temp[15] = OE_64_1[(((64*i+j+33)*width)-1)-:width];
				OE_64_1[(((64*i+j+33)*width)-1)-:width] = OE_64_1[(((64*i+j+1)*width)-1)-:width];
				OE_64_1[(((64*i+j+1)*width)-1)-:width] = temp[15];
				//swap index
				index_temp[15] = index15[64*i+j+32];
				index15[64*i+j+32] = index15[64*i+j];
				index15[64*i+j] = index_temp[15];
			end
		end
	end
end
always@(*)
begin
	//OE_64_2
	OE_64_2 = OE_64_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index16[i]} = {index16_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<16;j=j+1)
		begin
			if(OE_64_2[(((64*i+j+17)*width)-1)-:width] < OE_64_2[(((64*i+j+33)*width)-1)-:width])             
			begin
				//swap candidate
				temp[16] = OE_64_2[(((64*i+j+33)*width)-1)-:width];
				OE_64_2[(((64*i+j+33)*width)-1)-:width] = OE_64_2[(((64*i+j+17)*width)-1)-:width];
				OE_64_2[(((64*i+j+17)*width)-1)-:width] = temp[16];
				//swap index
				index_temp[16] = index16[64*i+j+32];
				index16[64*i+j+32] = index16[64*i+j+16];
				index16[64*i+j+16] = index_temp[16];
			end
		end
	end
end
always@(*)
begin
	//OE_64_3
	OE_64_3 = OE_64_3_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index17[i]} = {index17_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<3;j=j+1)
		begin
			for(k=0;k<8;k=k+1)
			begin
				if(OE_64_3[(((64*i+16*j+k+9)*width)-1)-:width] < OE_64_3[(((64*i+16*j+k+17)*width)-1)-:width])             
				begin
					//swap candidate
					temp[17] = OE_64_3[(((64*i+16*j+k+17)*width)-1)-:width];
					OE_64_3[(((64*i+16*j+k+17)*width)-1)-:width] = OE_64_3[(((64*i+16*j+k+9)*width)-1)-:width];
					OE_64_3[(((64*i+16*j+k+9)*width)-1)-:width] = temp[17];
					//swap index
					index_temp[17] = index17[64*i+16*j+k+16];
					index17[64*i+16*j+k+16] = index17[64*i+16*j+k+8];
					index17[64*i+16*j+k+8] = index_temp[17];
				end
			end
		end
	end
end
always@(*)
begin
	//OE_64_4
	OE_64_4 = OE_64_4_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index18[i]} = {index18_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<7;j=j+1)
		begin
			for(k=0;k<4;k=k+1)
			begin
				if(OE_64_4[(((64*i+8*j+k+5)*width)-1)-:width] < OE_64_4[(((64*i+8*j+k+9)*width)-1)-:width])             
				begin
					//swap candidate
					temp[18] = OE_64_4[(((64*i+8*j+k+9)*width)-1)-:width];
					OE_64_4[(((64*i+8*j+k+9)*width)-1)-:width] = OE_64_4[(((64*i+8*j+k+5)*width)-1)-:width];
					OE_64_4[(((64*i+8*j+k+5)*width)-1)-:width] = temp[18];
					//swap index
					index_temp[18] = index18[64*i+8*j+k+8];
					index18[64*i+8*j+k+8] = index18[64*i+8*j+k+4];
					index18[64*i+8*j+k+4] = index_temp[18];
				end
			end
		end
	end
end
always@(*)
begin
	//OE_64_5
	OE_64_5 = OE_64_5_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index19[i]} = {index19_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<15;j=j+1)
		begin
			for(k=0;k<2;k=k+1)
			begin
				if(OE_64_5[(((64*i+4*j+k+3)*width)-1)-:width] < OE_64_5[(((64*i+4*j+k+5)*width)-1)-:width])             
				begin
					//swap candidate
					temp[19] = OE_64_5[(((64*i+4*j+k+5)*width)-1)-:width];
					OE_64_5[(((64*i+4*j+k+5)*width)-1)-:width] = OE_64_5[(((64*i+4*j+k+3)*width)-1)-:width];
					OE_64_5[(((64*i+4*j+k+3)*width)-1)-:width] = temp[19];
					//swap index
					index_temp[19] = index19[64*i+4*j+k+4];
					index19[64*i+4*j+k+4] = index19[64*i+4*j+k+2];
					index19[64*i+4*j+k+2] = index_temp[19];
				end
			end
		end
	end
end
always@(*)
begin
	//OE_64_6
	OE_64_6 = OE_64_6_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index20[i]} = {index20_D[i]};
	end 
	for(i=0;i<2;i=i+1)
	begin
		for(j=0;j<31;j=j+1)
		begin
			if(OE_64_6[(((64*i+2*j+2)*width)-1)-:width] < OE_64_6[(((64*i+2*j+3)*width)-1)-:width])             
			begin
				//swap candidate
				temp[20] = OE_64_6[(((64*i+2*j+3)*width)-1)-:width];
				OE_64_6[(((64*i+2*j+3)*width)-1)-:width] = OE_64_6[(((64*i+2*j+2)*width)-1)-:width];
				OE_64_6[(((64*i+2*j+2)*width)-1)-:width] = temp[20];
				//swap index
				index_temp[20] = index20[64*i+2*j+2];
				index20[64*i+2*j+2] = index20[64*i+2*j+1];
				index20[64*i+2*j+1] = index_temp[20];
			end
		end
	end
end
always@(*)
begin
	//OE_128_1
	OE_128_1 = OE_128_1_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index21[i]} = {index21_D[i]};
	end 
	for(i=0;i<64;i=i+1)
	begin
		if(OE_128_1[(((i+1)*width)-1)-:width] < OE_128_1[(((i+65)*width)-1)-:width])             
		begin
			//swap candidate
			temp[21] = OE_128_1[(((i+65)*width)-1)-:width];
			OE_128_1[(((i+65)*width)-1)-:width] = OE_128_1[(((i+1)*width)-1)-:width];
			OE_128_1[(((i+1)*width)-1)-:width] = temp[21];
			//swap index
			index_temp[21] = index21[i+64];
			index21[i+64] = index21[i];
			index21[i] = index_temp[21];
		end
	end
end
always@(*)
begin
	//OE_128_2
	OE_128_2 = OE_128_2_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index22[i]} = {index22_D[i]};
	end 
	for(i=0;i<32;i=i+1)
	begin
		if(OE_128_2[(((i+33)*width)-1)-:width] < OE_128_2[(((i+65)*width)-1)-:width])             
		begin
			//swap candidate
			temp[22] = OE_128_2[(((i+65)*width)-1)-:width];
			OE_128_2[(((i+65)*width)-1)-:width] = OE_128_2[(((i+33)*width)-1)-:width];
			OE_128_2[(((i+33)*width)-1)-:width] = temp[22];
			//swap index
			index_temp[22] = index22[i+64];
			index22[i+64] = index22[i+32];
			index22[i+32] = index_temp[22];
		end
	end
end
always@(*)
begin
	//OE_128_3
	OE_128_3 = OE_128_3_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index23[i]} = {index23_D[i]};
	end 
	for(i=0;i<3;i=i+1)
	begin
		for(j=0;j<16;j=j+1)
		begin
			if(OE_128_3[(((32*i+j+17)*width)-1)-:width] < OE_128_3[(((32*i+j+33)*width)-1)-:width])             
			begin
				//swap candidate
				temp[23] = OE_128_3[(((32*i+j+33)*width)-1)-:width];
				OE_128_3[(((32*i+j+33)*width)-1)-:width] = OE_128_3[(((32*i+j+17)*width)-1)-:width];
				OE_128_3[(((32*i+j+17)*width)-1)-:width] = temp[23];
				//swap index
				index_temp[23] = index23[32*i+j+32];
				index23[32*i+j+32] = index23[32*i+j+16];
				index23[32*i+j+16] = index_temp[23];
			end
		end
	end
end
always@(*)
begin
	//OE_128_4
	OE_128_4 = OE_128_4_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index24[i]} = {index24_D[i]};
	end 
	for(i=0;i<7;i=i+1)
	begin
		for(j=0;j<8;j=j+1)
		begin
			if(OE_128_4[(((16*i+j+9)*width)-1)-:width] < OE_128_4[(((16*i+j+17)*width)-1)-:width])             
			begin
				//swap candidate
				temp[24] = OE_128_4[(((16*i+j+17)*width)-1)-:width];
				OE_128_4[(((16*i+j+17)*width)-1)-:width] = OE_128_4[(((16*i+j+9)*width)-1)-:width];
				OE_128_4[(((16*i+j+9)*width)-1)-:width] = temp[24];
				//swap index
				index_temp[24] = index24[16*i+j+16];
				index24[16*i+j+16] = index24[16*i+j+8];
				index24[16*i+j+8] = index_temp[24];
			end
		end
	end
end
always@(*)
begin
	//OE_128_5
	OE_128_5 = OE_128_5_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index25[i]} = {index25_D[i]};
	end 
	for(i=0;i<15;i=i+1)
	begin
		for(j=0;j<4;j=j+1)
		begin
			if(OE_128_5[(((8*i+j+5)*width)-1)-:width] < OE_128_5[(((8*i+j+9)*width)-1)-:width])             
			begin
				//swap candidate
				temp[25] = OE_128_5[(((8*i+j+9)*width)-1)-:width];
				OE_128_5[(((8*i+j+9)*width)-1)-:width] = OE_128_5[(((8*i+j+5)*width)-1)-:width];
				OE_128_5[(((8*i+j+5)*width)-1)-:width] = temp[25];
				//swap index
				index_temp[25] = index25[8*i+j+8];
				index25[8*i+j+8] = index25[8*i+j+4];
				index25[8*i+j+4] = index_temp[25];
			end
		end
	end
end
always@(*)
begin
	//OE_128_6
	OE_128_6 = OE_128_6_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index26[i]} = {index26_D[i]};
	end 
	for(i=0;i<31;i=i+1)
	begin
		for(j=0;j<2;j=j+1)
		begin
			if(OE_128_6[(((4*i+j+3)*width)-1)-:width] < OE_128_6[(((4*i+j+5)*width)-1)-:width])             
			begin
				//swap candidate
				temp[26] = OE_128_6[(((4*i+j+5)*width)-1)-:width];
				OE_128_6[(((4*i+j+5)*width)-1)-:width] = OE_128_6[(((4*i+j+3)*width)-1)-:width];
				OE_128_6[(((4*i+j+3)*width)-1)-:width] = temp[26];
				//swap index
				index_temp[26] = index26[4*i+j+4];
				index26[4*i+j+4] = index26[4*i+j+2];
				index26[4*i+j+2] = index_temp[26];
			end
		end
	end
end
always@(*)
begin
	//OE_128_7
	OE_128_7 = OE_128_7_D;
	for(i=0;i<quantity;i=i+1)
	begin
		{index27[i]} = {index27_D[i]};
	end 
	for(i=0;i<63;i=i+1)
	begin
		if(OE_128_7[(((2*i+2)*width)-1)-:width] < OE_128_7[(((2*i+3)*width)-1)-:width])             
		begin
			//swap candidate
			temp[27] = OE_128_7[(((2*i+3)*width)-1)-:width];
			OE_128_7[(((2*i+3)*width)-1)-:width] = OE_128_7[(((2*i+2)*width)-1)-:width];
			OE_128_7[(((2*i+2)*width)-1)-:width] = temp[27];
			//swap index
			index_temp[27] = index27[2*i+2];
			index27[2*i+2] = index27[2*i+1];
			index27[2*i+1] = index_temp[27];
		end
	end
end
endmodule