module hazard_unit (input [4:0] rs_D,
		    input [4:0] rt_D,
		    input branch_D,
		    input memtoreg_E,
		    input regwrite_E,
		    input [4:0] writereg_E,
		    input [4:0] rt_E,
		    input memtoreg_M,
		    input [4:0] writereg_M,
		    output reg stall_F,
		    output reg stall_D,
 	      	    output reg flush_E);

    always @(*)
	//load hazard - load word stall
          if (((rs_D == rt_E) | (rt_D == rt_E)) & memtoreg_E) begin
		stall_F <= 1'b1;
		stall_D <= 1'b1;
		flush_E <= 1'b1;
	   end
       // branch stall
          else if ((branch_D & regwrite_E & ((writereg_E == rs_D) | (writereg_E == rt_D))) | (branch_D & memtoreg_M & ((writereg_M == rs_D) | (writereg_M == rt_D)))) begin 
                stall_F <= 1'b1;
                stall_D <= 1'b1;
                flush_E <= 1'b1;
	   end
	   else  begin
		stall_F <= 1'b0;
		stall_D <= 1'b0;
		flush_E <= 1'b0;
	  end

endmodule


		
