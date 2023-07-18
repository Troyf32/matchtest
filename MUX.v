module MUX
#(
    parameter   m = 8, // m width
    parameter   n = 8, // n mux input
    parameter   width = 3 //select width
)
(
     input   [n*m-1:0]   pdata //parallel data in
    ,input   [width-1:0] s   //select width
    ,output  [m-1:0]     data_o //out
);
assign  data_o =   pdata[(m*(s+1)-1)-:m];

endmodule

//  MUX #(
//         .m(3)
//        ,.n(2)
//        ,.width(1)
//    ) 
//    mux1 ( .pdata({in1,in2})
//          ,.s(s)
//          ,.data_o(out)
//         );