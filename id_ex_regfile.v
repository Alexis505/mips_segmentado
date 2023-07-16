module id_ex_regfile (input clk,
		      input flush_E,
		      input regwrite_D,
		      input memtoreg_D,
		      input memwrite_D,
		      input [2:0] alucontrol_D,
		      input alusrc_D,
		      input regdst_D,
		      input [31:0] rd1_D, //read data 1
		      input [31:0] rd2_D, //read data 2
		      input [4:0] rs_D, //first source register
		      input [4:0]  rt_D, // second source register
		      input [4:0]  rd_D, //register destination
		      input [31:0] SignImm_D, //immediate sign extended
		      input [31:0] pcplus4_D,
                      output reg regwrite_E,
		      output reg memtoreg_E,
		      output reg memwrite_E,
		      output reg [2:0] alucontrol_E,
		      output reg alusrc_E,
		      output reg regdst_E,
		      output reg [31:0] rd1_E,
		      output reg [31:0] rd2_E,
		      output reg [4:0] rs_E,
		      output reg [4:0] rt_E,
		      output reg [4:0] rd_E,
		      output reg [31:0] SignImm_E,
		      output reg [31:0] pcplus4_E);

    always @(posedge clk)
	    if (flush_E) begin
		    regwrite_E <= 0;
		    memtoreg_E <= 0;
		    memwrite_E <= 0;
		    alucontrol_E <= 3'b000;
		    alusrc_E <= 0;
		    regdst_E <= 0;
		    rd1_E <= 32'b0;
	    	    rd2_E <= 32'b0;
		    rs_E  <= 32'b0;
		    rt_E  <= 32'b0;
		    rd_E  <= 32'b0;
	            SignImm_E <= 32'b0;
		    pcplus4_E <= 32'b0;
		end
	    else
	    begin
		    regwrite_E <= regwrite_D;
		    regwrite_E <= regwrite_D;
		    memtoreg_E <= memtoreg_D;
		    memwrite_E <= memwrite_D;
		    alucontrol_E <= alucontrol_D;
		    alusrc_E <= alusrc_D;
		    regdst_E <= regdst_D;
		    rd1_E <= rd1_D;
	    	    rd2_E <= rd2_D;
		    rs_E  <= rs_D;
		    rt_E  <= rt_D;
		    rd_E  <= rd_D;
	            SignImm_E <= SignImm_D;
		    pcplus4_E <= pcplus4_D;
	    end


endmodule
