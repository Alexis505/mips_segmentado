module pc_if_regfile (input clk,
		      input stall_F,
		      input [31:0] pc,
		      output reg [31:0] pc_F);

    always @(posedge clk) begin
	    if (stall_F)
		    pc_F <= pc_F;
	    else
		    pc_F <= pc;
    end

endmodule

