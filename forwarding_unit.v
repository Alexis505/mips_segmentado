module forwarding_unit (input [4:0] rs_D,
			input [4:0] rt_D,
			input [4:0] rs_E,
                        input [4:0] rt_E,
			input regwrite_M,
			input [4:0] writereg_M,
			input regwrite_W,
			input [4:0] writereg_W,
			output forwardA_D,
			output forwardB_D,
			output reg [1:0] forwardA_E,
			output reg [1:0] forwardB_E);


assign forwardA_D = ((rs_D != 0) & (rs_D == writereg_M) & (regwrite_M)) ? 1:0;
assign forwardB_D = ((rt_D != 0) & (rt_D == writereg_M) & (regwrite_M)) ? 1:0;

    always @(*)
        //ex hazard for forwardA_E
	if ((rs_E != 0) & (rs_E == writereg_M ) & (regwrite_M))
		forwardA_E <= 2'b10;
	//mem hazard
	else if ((rs_E != 0) & (rs_E == writereg_W) & (regwrite_W))
		forwardA_E <= 2'b01;
	else
		forwardA_E <= 2'b00;
   
     always @(*)
        //ex hazard for forwardB_E
        if ((rt_E != 0) & (rt_E == writereg_M ) & (regwrite_M))
                forwardB_E <= 2'b10;
        //mem hazard
        else if ((rt_E != 0) & (rt_E == writereg_W) & (regwrite_W))
                forwardB_E <= 2'b01;
        else
                forwardB_E <= 2'b00;

endmodule			 
