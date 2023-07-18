`timescale 1ns / 1ps
 
module read_bmp_tb;
 
integer iBmpFileId,iOutFileId,iIndex=0,iCode;
reg [7:0] rBmpData [0:200000];
reg [31:0] rBmpCom;
reg [7:0]temp[0:3];
reg [7:0]abs_temp[0:3];
integer iBmpWidth,iBmpHight,iDataStartIndex,iBmpSize;
 
initial begin
	iBmpFileId = $fopen("D:\\FPGA_Troy\\match_score\\a.bmp","rb+");
	iOutFileId = $fopen("D:\\FPGA_Troy\\match_score\\output.bmp","wb+");
	
	iCode = $fread(rBmpData,iBmpFileId);
	iBmpWidth = {rBmpData[21],rBmpData[20],rBmpData[19],rBmpData[18]};
	iBmpHight = {rBmpData[25],rBmpData[24],rBmpData[23],rBmpData[22]};
	iDataStartIndex = {rBmpData[13],rBmpData[12],rBmpData[11],rBmpData[10]};
	iBmpSize = {rBmpData[5],rBmpData[4],rBmpData[3],rBmpData[2]};
	$fclose(iBmpFileId);
 
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
	
	rBmpCom = {rBmpData[iIndex+3],rBmpData[iIndex+2],rBmpData[iIndex+1],rBmpData[iIndex]};
	
		$display("%h",rBmpData[iIndex]);
		#20;
		//$fwrite(iOutFileId,"%u",rBmpCom);
	end // for
	$fclose(iOutFileId);
end
 
endmodule
