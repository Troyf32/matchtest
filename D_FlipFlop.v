module D_FlipFlop
    #(  
     parameter       isposedge = 1 
    ,parameter       ini = 0 )
    (
     input D
    ,input clk
    ,input rst
    ,input en
    ,output reg q
    );
    wire clk_t = isposedge?clk:~clk;

    always@(posedge clk_t , negedge rst )
    begin
        if(!rst)
            q <= ini;
        else
            if(en)
                q <= D;
            else
                q <= q;
    end
    
endmodule