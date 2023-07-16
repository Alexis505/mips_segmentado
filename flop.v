module flop #(parameter WIDTH = 8) (input clk, reset,
				    input stall_F,
				    input [WIDTH-1:0] d,
				    output reg [WIDTH-1:0] q);

always @(posedge clk, posedge reset)
	if (reset) q <= 0;
	else if (stall_F)  q <= q;
	else q <= d;
endmodule
