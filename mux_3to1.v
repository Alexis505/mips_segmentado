//ux_3to1 #(32) srca_E_mux(rd1_E,result_W,aluout_M,forward_a,srca_E);
module mux_3to1 #(parameter N = 8)
	(input [N-1:0] read_data_E,result_W,aluout_M,
	 input [1:0] forward,
	 output reg [N-1:0] src_E);

always @(*)
begin
	if (forward==2'b10)
		src_E <= aluout_M;
	else if (forward==2'b01)
		src_E <= result_W;
	else if (forward==2'b00)
		src_E <= read_data_E;
	else
		src_E <= 8'bx;
end 

endmodule

	


