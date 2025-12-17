module controller (
    input  logic        clk,
    input  logic        reset,

    input  logic [6:0]  op,
    input  logic [2:0]  funct3,
    input  logic        funct7b5,
    input  logic        zero,

    output logic [2:0]  immsrc,
    output logic [1:0]  alusrca, alusrcb,
    output logic [1:0]  resultsrc,
    output logic        adrsrc,
    output logic [2:0]  alucontrol,
    output logic        irwrite,
    output logic        pcwrite,
    output logic        regwrite,
    output logic        memwrite
);

    // FSM signals
    logic branch;
    logic pcupdate;
    logic [1:0] aluop;

    //==============================
    // Main FSM Instance
    //==============================
    fsm MainFSM (
        .clk       (clk),
        .rst       (reset),
        .op        (op),
        .branch    (branch),
        .pcupdate  (pcupdate),
        .regwrite  (regwrite),
        .memwrite  (memwrite),
        .irwrite   (irwrite),
        .resultsrc (resultsrc),
        .alusrcb   (alusrcb),
        .alusrca   (alusrca),
        .adrsrc    (adrsrc),
        .aluop     (aluop)
    );

    //==============================
    // ALU Decoder
    //==============================
	ALUDecoder ALU_Decoder (
		.op_5      (op[5]),
		.funct3    (funct3),
		.funct7_5  (funct7b5),
		.ALUop     (aluop),
		.ALUControl(alucontrol)
	);

    //==============================
    // Immediate Decoder
    //==============================
    instrDec Instr_Decoder (
        .op     (op),
        .immsrc (immsrc)
    );

    //==============================
    // PC Write Logic
    //==============================
    assign pcwrite = (zero & branch) | pcupdate;

endmodule

