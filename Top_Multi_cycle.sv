module top_multi_cycle(input  logic        clk, reset, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite);

logic [31:0] ReadData;

RISC_V_Multi_Cycle rvMulti(clk, reset, ReadData, DataAdr, MemWrite, WriteData);
memory mem(clk, MemWrite, DataAdr, WriteData, ReadData);

 
endmodule
