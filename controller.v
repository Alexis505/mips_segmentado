module controller (input [5:0] opcode, // opcode r-type,lw,sw....
		   input [5:0] funct, //funct para r-type
		   input equal_D, //1 si la resta de los dos registros en un beq es 0
		   output regdst, alusrc, memtoreg, regwrite, memread, memwrite,jump,
		   output pcsrc_D, // senal para saber si se debe dar un salto o no
		   output branch_D,
		   output [2:0] alucontrol);

//branch es wire y no output porque llega a la compuerta and dentro de este mismo controller
//aluop es wire porque llega solo hasta aludec, en realidad no sale de controller
//wire branch_D;
wire[1:0] aluop;

maindec	md(opcode, regdst, alusrc, memtoreg, regwrite, memread, memwrite, branch_D, jump, aluop);

aludec ad(funct, aluop, alucontrol);

assign pcsrc_D = branch_D & equal_D;

endmodule
