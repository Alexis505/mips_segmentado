module datapath (input clk, 
		 input reset,
		 input regwrite_D, 
		 input memtoreg_D, 
		 input memwrite_D, 
		 input [2:0] alucontrol_D,
		 input alusrc_D,
		 input regdst_D,
		 input pcsrc_D,
		 input branch_D,
                 input[31:0] instr_D,
		 input[31:0] pcplus4_D,
                 input[31:0] read_data_M, 
		 output equal_D,
		 output[31:0] aluout_M,
                 output[31:0] writedata_M, 
	         output stall_D,
		 output memwrite_M,
		 input [31:0] pcplus4_F,
		 output[31:0] pc);

//**********
//entradas a if_id_regfile
//**********
//wire[31:0] pcplus4_F; 
//instr_F viene de la mem de instrs por lo que es una entrada al modulo
wire stall_F;
//wire pcsrc_D;
//wire stall_D;


//****
//salidas de if_id_regfile
//****
//wire [31:0] instr_D;
//wire [31:0] pcplus4_D;

//****
//entradas a id_ex_regfile
//****
//las senales de control entran al modulo dp
wire [31:0] rd1,rd2; //estas dos no entran y se generan del regfile
//wire equal_D;
wire [31:0] rd1_D,rd2_D; //read data 1 y 2
wire [4:0] rs_D; 
wire [4:0] rt_D,rd_D;  //address of both 2nd src reg and dest reg
wire flush_E; //clear id_ex_reg
wire [31:0] result; //wire para escoger entre la data mem o alu result
wire [31:0] signimm_D;
// fin de de entradas a id_Ex_regfile

//signimm_D << 2 / multiplica por 4
wire [31:0] signimmsh_D;

//wire para branch
wire [31:0] pc_branch_D;
//pc_nextbr, pc_next;
//wire para asignar el siguiente pc
wire [31:0] pc_next;

//salidas de id_ex_regfile
wire regwrite_E,memtoreg_E,memwrite_E,alusrc_E,regdst_E;
wire [2:0] alucontrol_E;
wire [31:0] rd1_E, rd2_E;
wire [4:0] rs_E,rt_E,rd_E;
wire [31:0] signimm_E;
wire [31:0] pcplus4_E;

//wires para alu
wire [31:0] srca_E;
wire [31:0] srcb_E;

//entradas ex_mem_regfile
wire [31:0] aluout_E;
//wire regwrite_E,memtoreg_E,memwrite_E;
wire [31:0] writedata_E;
wire [4:0] writereg_E; //wire para contener instr[20-16] o instr[15-11]

//salidas ex_mem_regfile
wire regwrite_M,memtoreg_M;
//wire [31:0] aluout_M;
//wire [31:0] writedata_M; estas dos son salidas del modulo
wire [4:0]  writereg_M;

//salidas mem_wb_regfile
wire regwrite_W,memtoreg_W;
wire [31:0] read_data_W;
wire [31:0] aluout_W;
wire [4:0]  writereg_W;

//salida de la etapa de wb
wire[31:0] result_W;

//wires para forwarding unit
wire forwardA_D;
wire forwardB_D;
wire [1:0] forwardA_E;
wire [1:0] forwardB_E;
//nota: crear wires para las senales nuevas como los stalls
//cear para instr_f que debe salir de la instruction memory

//calculamos los posibles siguientes PC
//establecemos el siguiente pc en base a pc_next 
//pc_next contiene el siguiente pc definitivo
//para esta vesion en segmentado, agregamos un habilitador al registro 
//del pc, que en este caso sera la senal de stall
mux2 #(32) pcbranch(pcplus4_F,pc_branch_D,pcsrc_D,pc_next);
flop #(32) fp(clk, reset,stall_F, pc_next, pc);
//adder pcplus4(pc,32'b100,pcplus4_F);

//if_id_regfile if_id_instance(clk,stall_D,pcsrc_D,instr_F,pcplus4_F,instr_D,pcplus4_D);

//decode stage

//extension de 16b a 32b
signext signxt_imm(instr_D[15:0],signimm_D);
assign rs_D = instr_D[25:21];
assign rt_D = instr_D[20:16];
assign rd_D = instr_D[15:11];
//logica para el reg file
regfile regfile(clk,regwrite_W,instr_D[25:21],instr_D[20:16],writereg_W,result_W,rd1,rd2);
mux2 #(32) rd1_mux(rd1,aluout_M,forwardA_D,rd1_D);
mux2 #(32) rd2_mux(rd2,aluout_M,forwardB_D,rd2_D);
comparator #(32) comparision_beq(rd1_D,rd2_D,equal_D);
//assign pcsrc_D = branch_D && equal_D;

//shift left by 2
sl2 immshll(signimm_D,signimmsh_D);
//suma de signimmsh y plplus4
adder pcbranch_addr(pcplus4_D,signimmsh_D,pc_branch_D);

hazard_unit hazard_unit(rs_D,rt_D,branch_D,memtoreg_E,regwrite_E,writereg_E,rt_E,memtoreg_M,writereg_M,stall_F,stall_D,flush_E);

id_ex_regfile id_ex_instance(clk,flush_E,regwrite_D,memtoreg_D,memwrite_D,alucontrol_D,alusrc_D,regdst_D,rd1_D,rd2_D,rs_D,rt_D,rd_D,signimm_D,pcplus4_D,regwrite_E,memtoreg_E,memwrite_E,alucontrol_E,alusrc_E,regdst_E,rd1_E,rd2_E,rs_E,rt_E,rd_E,signimm_E,pcplus4_E);

//
//etapa de ejecucion
//
//mux para decidir entre id_ex_rt y id_ex_rd como destino a escribir
mux2 #(5) mux_wreg(rt_E,rd_E,regdst_E,writereg_E);

//mux para tomar valor etapa de ex, mem o wb
mux_3to1 #(32) srca_E_mux(rd1_E,result_W,aluout_M,forwardA_E,srca_E);
mux_3to1 #(32) srcb_E_mux(rd2_E,result_W,aluout_M,forwardB_E,writedata_E);
mux2 #(32) alusrcb_mux(writedata_E,signimm_E,alusrc_E,srcb_E);
alu alu_inst(srca_E,srcb_E,alucontrol_E,aluout_E);

forwarding_unit forwarding_unit(rs_D,rt_D,rs_E,rt_E,regwrite_M,writereg_M,regwrite_W,writereg_W,forwardA_D,forwardB_D,forwardA_E,forwardB_E);

//*****
//etapa de memoria / memory stage
//***
ex_mem_regfile ex_mem_instance(clk,regwrite_E,memtoreg_E,memwrite_E,aluout_E,writedata_E,writereg_E,regwrite_M,memtoreg_M,memwrite_M,aluout_M,writedata_M,writereg_M);
//la memoria de datos es un modulo aparte que recibe aluout_M
//y writedata_M,clk y write enable (que es memwrite_M)
//ademas writereg_M van hacia la hazard unit
//aluout se retroalimenta hacia varias etapas atras


//************
//etapa de escritura de registro / write back stage
//***********
mem_wb_regfile mem_wb_instance(clk,regwrite_M,memtoreg_M,read_data_M,aluout_M,writereg_M,regwrite_W,memtoreg_W,read_data_W,aluout_W,writereg_W);
mux2 #(32) mux_result(aluout_W,read_data_W,memtoreg_W,result_W);

endmodule

