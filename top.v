module top (input clk,reset,
	    output[31:0] write_data, data_addr,
	    output memwrite_M, mem_read);

//top es el nombre de un modulo que seria el conjunto de 
//el procesador mips, la data mem y la instr mem
//por eso en la entrada solo esta clk, reset 
//y ala salida write_data .....

//cables internos del modulo top serian
wire[31:0] pc, instr_F, read_data;

//instanciamos
mips mips(clk,reset,instr_F,read_data,memwrite_M,mem_read,data_addr,write_data,pc);

//intr mem recibe solo 6 bits para esta simulacion sera suficiente
imem imem(pc[7:2],instr_F);

//data mem puede ser leida o escrita dependiendo de las senales
//mem_write y mem_read respectivamente
dmem dmem(clk,memwrite_M,mem_read,data_addr,write_data,read_data);

endmodule
