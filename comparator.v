module comparator #(parameter N = 8)
		(input [N-1:0] a,b,
		 output equal);

assign equal = (a == b);

endmodule


