module debounce_sw(in,
						 out,
						 clk,
						 rst);
						 
input	in, clk, rst;						 
output reg out;

reg [2:0] ns, cs;


always@(*)
begin
	case(cs)
	3'd0:
		ns = (in)?3'd1:3'd0;
	3'd1:             
		ns = (in)?3'd2:3'd0;
	3'd2:             
		ns = (in)?3'd3:3'd0;
	3'd3:             
		ns = (in)?3'd4:3'd0;
	3'd4:             
		ns = (in)?3'd5:3'd0;
	3'd5:             
		ns = (in)?3'd5:3'd0;
	default:
		ns = 3'd0;
	endcase
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin	
		cs <= 3'd0;
	end
	else
	begin
		cs <= ns;
	end
end

always@(*)
begin
	case(cs)
	3'd0:
		out = 1'b0;
	3'd1:
		out = 1'b0;
	3'd2:
		out = 1'b0;
	3'd3:
		out = 1'b0;
	3'd4:
		out = 1'b0;
	3'd5:
		out = 1'b1;
	default:
		out = 1'b0;
	endcase
end

endmodule