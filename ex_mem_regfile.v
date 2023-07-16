module ex_mem_regfile (input clk,
	               input regwrite_E,
		       input memtoreg_E,
		       input memwrite_E,
		       input [31:0] ALU_out_E,
		       input [31:0] write_data_E,
		       input [4:0] write_reg_E,
		       output reg regwrite_M,
		       output reg memtoreg_M,
		       output reg memwrite_M,
		       output reg [31:0] ALU_out_M,
		       output reg [31:0] write_data_M,
		       output reg [4:0] write_reg_M);

    always @(posedge clk)
    begin
	regwrite_M <= regwrite_E;
	memtoreg_M <= memtoreg_E;
	memwrite_M <= memwrite_E;
	ALU_out_M  <= ALU_out_E;
        write_data_M <= write_data_E;
        write_reg_M  <= write_reg_E;
    end

    
endmodule    



