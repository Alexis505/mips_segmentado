module mem_wb_regfile (input clk,
		       input regwrite_M,
		       input memtoreg_M,
		       input [31:0] read_data_M,
		       input [31:0] aluout_M,
		       input [4:0] writereg_M,
		       output reg regwrite_W,
		       output reg memtoreg_W,
		       output reg [31:0] read_data_W,
		       output reg [31:0] aluout_W,
		       output reg [4:0] writereg_W);


    always @(posedge clk)
    begin
	    regwrite_W <= regwrite_M;
	    memtoreg_W <= memtoreg_M;
	    read_data_W <= read_data_M;
	    aluout_W   <= aluout_M;
	    writereg_W <= writereg_M;
    end 

endmodule


