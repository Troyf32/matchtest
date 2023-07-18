module state_view(
 input in_range,
 input rst_n,
 input col_even_odd,
 input clk100m,
 input inRam_wrStart,
 input inRam_wrFinal,
 output reg[2:0]mode,
 output reg [1:0]rdSramCount
);
reg [3:0]state_c, state_n;

`define DELAY_1clk  (cnt==1'b1)

parameter IDLE = 4'd0,//IDLE
    REA0 = 4'd1,//read even all
    REA1 = 4'd2,//read even LB
    REA2 = 4'd3,//read odd UB
    REA3 = 4'd4,//read odd all
    WRT0 = 4'd5,//write LB
    WRT1 = 4'd6;//write UB
 
  reg cnt;
    //delay count
    always@(posedge clk100m or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt<=1'b0;
        end
        else if(state_c==IDLE)begin
            cnt<=1'b0;
        end
        else begin
            cnt<=cnt+1'b1;
        end
    end
 
 //狀態機
    always@(posedge clk100m or negedge rst_n)begin
        if(~rst_n)begin
            state_c<=IDLE;
        end
        else begin
            state_c<=state_n;
        end
    end
    
 always@(state_c or in_range or inRam_wrStart or inRam_wrFinal or cnt or col_even_odd)begin
  case(state_c)
   IDLE:if(inRam_wrFinal==1'b1)begin
       state_n<=IDLE;
     end
     else if(inRam_wrStart==1'b1)begin
       state_n<=WRT0;
     end
     else if(in_range==1'b1)begin
     if(col_even_odd ==1'b0) begin
      state_n<=REA0;
     end
     else begin
      state_n<=REA2;
     end
     end
     else begin
       state_n<=IDLE;
     end
     
   WRT0: 
    if(`DELAY_1clk)begin
     state_n<=WRT1;
    end
    else begin
     state_n<=WRT0;
    end
   WRT1:
    if (inRam_wrFinal==1'b1)begin
     state_n<=IDLE;
    end
    else if(`DELAY_1clk)begin
     state_n<=WRT0;
    end
    else begin
     state_n<=WRT1;
    end 
    
   REA0: state_n<=REA1;
   REA1: begin
    if(in_range == 1'b0)begin
     state_n<=IDLE;
    end
    else if(col_even_odd ==1'b0)begin
     state_n<=REA0;
    end
    else begin
     state_n<=REA2;
    end
   end
   REA2: state_n<=REA3;
   REA3: 
    if(in_range == 1'b0)begin
     state_n<=IDLE;
    end
    else if(col_even_odd ==1'b0) begin
     state_n<=REA0;
    end
    else begin
     state_n<=REA2;
    end
   
   default:state_n<=IDLE;
  endcase
 end

 //output
  always@(posedge clk100m or negedge rst_n)begin
        if(~rst_n)begin
            mode<=3'b000;
    rdSramCount<= 2'b00;
        end
        else if (state_c == IDLE)begin
            mode<=3'b000;
    rdSramCount<= 2'b00;
        end
    else if (state_c == REA0)begin
    mode<=3'b010;
    rdSramCount<= 2'b00;
    end
    else if (state_c == REA1)begin
    mode<=3'b010;
    rdSramCount<= 2'b01;
    end
    else if (state_c == REA2)begin
    mode<=3'b010;
    rdSramCount<= 2'b10;
    end
    else if (state_c == REA3)begin
    mode<=3'b010;
    rdSramCount<= 2'b11;
    end
    else if (state_c == WRT0)begin
    mode<=3'b100;
    end
    else if (state_c == WRT1)begin
    mode<=3'b101;
    end
    else begin
    mode<=3'b000;
    end
    end
  


endmodule