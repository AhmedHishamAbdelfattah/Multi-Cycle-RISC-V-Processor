module RISC_V_Multi_Cycle (
    input logic clk, reset,
    input logic [31:0] ReadData,
    output logic [31:0] Adr,
    output logic MemWrite,
    output logic [31:0] WriteData
);

    wire [1:0] ResultSrc, ALUSrcA, ALUSrcB;
    wire adrSrc, Zero;
    wire [2:0] ImmSrc;
	wire [2:0] alucontrol;
    wire irwrite, pcwrite;
    wire regwrite;
    wire [31:0] Instr;
    wire [31:0] Result ;
    wire [31:0] ALUOut;
    wire [31:0] ALUResult;
    wire [31:0] PC;
    wire [31:0] RD1;
    wire [31:0] RD2;

    controller c (
        clk, reset, Instr[6:0], Instr[14:12], Instr[30],
        Zero, ImmSrc, ALUSrcA, ALUSrcB, ResultSrc, adrSrc,
        alucontrol, irwrite, pcwrite, regwrite, MemWrite
    );

    dataPath dp (
        clk, reset, ImmSrc, alucontrol, ResultSrc, irwrite,
        regwrite, ALUSrcA, ALUSrcB, adrSrc, pcwrite,
        ReadData, Zero, Adr, WriteData, Instr, Result, ALUOut, ALUResult, PC, RD1, RD2);

endmodule
