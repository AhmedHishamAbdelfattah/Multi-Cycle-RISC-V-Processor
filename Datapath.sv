module dataPath (input logic clk, reset,
					  input logic [2:0] ImmSrc, 
					  input logic [2:0] ALUControl, 
					  input logic [1:0] ResultSrc, 
					  input logic IRWrite,
					  input logic RegWrite,
					  input logic [1:0] ALUSrcA, ALUSrcB, 
					  input logic AdrSrc, 
					  input logic PCWrite,  
					  input logic [31:0] ReadData,
					  output logic Zero, 
					  output logic [31:0] Adr, 
					  output logic [31:0] WriteData,
					  output logic [31:0] instr,
					  output logic [31:0] Result ,
					  output logic [31:0] ALUOut,
					  output logic [31:0] ALUResult,
					  output logic [31:0] PC,
					  output logic [31:0] RD1,
					  output logic [31:0] RD2);

		 
// logic [31:0] Result , ALUOut, ALUResult;
// logic [31:0] RD1, RD2, A , SrcA, SrcB, Data;
logic [31:0] SrcA, SrcB, Data;
logic [31:0] ImmExt;
logic [31:0] OldPC;


//pc
Register_enabled_block #(32) pcFlop(clk, reset, PCWrite, Result, PC);


//regFile
regFile rf(clk, RegWrite, instr[19:15], instr[24:20], instr[11:7], Result, RD1, RD2); 
extend ext(instr[31:7], ImmSrc, ImmExt);
Register_block #(32) regF( clk, reset, RD1, A);
Register_block #(32) regF_2( clk, reset, RD2, WriteData);


//alu
mux3 #(32) srcAmux(PC, OldPC, A, ALUSrcA, SrcA);
mux3 #(32) srcBmux(WriteData, ImmExt, 32'd4, ALUSrcB, SrcB);
ALU alu(SrcA, SrcB, ALUControl, Zero, ALUResult);
Register_block #(32) aluReg (clk, reset, ALUResult, ALUOut);
mux3 #(32) resultMux(ALUOut, Data, ALUResult, ResultSrc, Result );

//mem
mux2 #(32) adrMux(PC, Result, AdrSrc, Adr);
Register_enabled_block #(32) memFlop1(clk, reset, IRWrite, PC, OldPC); 
Register_enabled_block #(32) memFlop2(clk, reset, IRWrite, ReadData, instr);
Register_block #(32) memDataFlop(clk, reset, ReadData, Data);

endmodule
