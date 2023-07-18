module Debounce(buttonin, clicked, clk, r);
input buttonin, clk, r;
output reg clicked;
reg [3:0] decnt;

parameter bound=4'd4;

always@(posedge clk or negedge r)begin //button
 if(~r)begin
  decnt<=4'd0;
  clicked<=0;
 end
 else begin
  if(~buttonin)begin
   if(decnt<bound)begin
    decnt <= decnt+1'b1;
    clicked <=0;
   end
   else begin
    decnt <= decnt;
    clicked <=1;
   end
  end
  else begin
   decnt <=0;
   clicked <=0;
  end
 end
end

endmodule