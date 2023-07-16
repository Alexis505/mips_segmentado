module mips (input clk,reset,
	     input[31:0] instr_F,
	     input[31:0] read_data_M,
             output memwrite_M,
	     output memread_D,
	     output[31:0] aluout_M,
             output[31:0] writedata_M,
	     output[31:0] pc);

//en este intento, vamos a ver si podemos cambiar if_id_regfile desde datapath
//a mips
//esto incluye que establezcamos las entradas de if_id_regfile que no son
//entradas de mips, como wires en este modulo y como salidas del modulo de
//datapath
//entradas a establecer: stall_D, pcsrc_D, pcplus4_F
//pcsrc_D ya estaba declarado
//Traer logica para hacer la suma de pc + 4
wire stall_D;
wire [31:0] pcplus4_F;
//Tambien tenemos que establecer las dos salidas d if_id_instance como
//entradas a datapath y controller (instr_D[x:x])
wire [31:0] instr_D;
wire [31:0] pcplus4_D;

//wire para salida de controller y entrada a dp
wire memwrite_D;

wire regdst_D,alusrc_D,memtoreg_D,regwrite_D,jump,pcsrc_D,equal_D;
wire[2:0] alucontrol_D;
wire branch_D;

adder pcplus4(pc,32'b100,pcplus4_F);

if_id_regfile if_id_instance(clk,stall_D,pcsrc_D,instr_F,pcplus4_F,instr_D,pcplus4_D);

controller control(instr_D[31:26],instr_D[5:0],equal_D,regdst_D,alusrc_D,memtoreg_D,regwrite_D,memread_D,memwrite_D,jump,pcsrc_D,branch_D,alucontrol_D);

datapath dp(clk,reset,regwrite_D,memtoreg_D,memwrite_D,alucontrol_D,alusrc_D,regdst_D,pcsrc_D,branch_D,instr_D,pcplus4_D,read_data_M,equal_D,aluout_M,writedata_M,stall_D,memwrite_M,pcplus4_F,pc);


endmodule
