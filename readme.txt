En este procesador el unico problema que al parecer tenemos es que cuando
se intenta leer un dato del regfile parece ser que llega un tiempo tarde
(un ciclo de reloj) entonces intentaremos cambiar los 6 regfile para ver
si esto ordenamos escribir en posedge y leer en negedge resuelve el asunto
estos son pc(flop), if_id_regfile, regfile, id_ex_regfile, ex_mem_regfile
mem_wb_regfile.

Pareciera ser que solo tenemos ese problema porque los valores que llegan a 
write_address y writa_data del regfile (A3, WD3 en el libro de harris) si son
correctos, pero cuando se necesitan en el alu, estos valos no llegan a tiempo
por un ciclo de reloj.

Informacion valida a 4/jun/2023 22:56

Intentaremos solo cambiar el regfile 23:07
