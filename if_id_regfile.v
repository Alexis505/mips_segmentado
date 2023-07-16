module if_id_regfile (input clk,
		      input stall_D,
		      input pcsrc_D,
		      input [31:0] instr_F,
		      input [31:0] pcplus4_F,
		      output reg [31:0] instr_D,
	      	      output reg [31:0] pcplus4_D);
//reg [31:0] pc;
//reg [31:0] instr;
		      always @(posedge clk) begin
			      if (pcsrc_D)
			      begin
			     	      instr_D <= 32'b0;
			     	      pcplus4_D <= 32'b0;
			      end
			      else begin
			          if(stall_D) begin
				      instr_D <= instr_D;
				      pcplus4_D <= pcplus4_D;
			      end
			      else begin
				      instr_D <= instr_F;
				      pcplus4_D <= pcplus4_F;
			      end
			     end
		      end
		     // always @(negedge clk) 
		     // begin
		//	      instr_D <= instr_F;
		//	      pcplus4_D <= pcplus4_F;
		  //    end
endmodule
