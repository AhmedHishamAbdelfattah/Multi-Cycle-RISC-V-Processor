module ALUDecoder(
    input  logic op_5,           // Opcode bit 5
    input  logic [2:0] funct3,   // funct3 field
    input  logic funct7_5,       // bit 5 of funct7
    input  logic [1:0] ALUop,    // From main FSM
    output logic [2:0] ALUControl
);

    always_comb begin
        case (ALUop)
            // ----------------------------------------
            // ALUop = 00 → always ADD (for load/store)
            // ----------------------------------------
            2'b00: ALUControl = 3'b000; // ADD / ADDI
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 01 → always SUB (for branch)
            // ----------------------------------------
            2'b01: ALUControl = 3'b001; // SUB
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 10 → use funct3/funct7/op5 for R/I type
            // ----------------------------------------
            2'b10: begin
                casex({funct7_5, op_5, funct3})
                    // ADD / ADDI
                    5'b00_000: ALUControl = 3'b000;
                    5'b01_000: ALUControl = 3'b000;
                    5'b10_000: ALUControl = 3'b000;

                    // SUB
                    5'b11_000: ALUControl = 3'b001;

                    // SLT
                    5'bxx_010: ALUControl = 3'b101;

                    // OR 
                    5'bxx_110: ALUControl = 3'b011;

                    // AND
                    5'bxx_111: ALUControl = 3'b010;

                    default: ALUControl = 3'bxxx;
                endcase
            end

            default: ALUControl = 3'bxxx;
        endcase
    end

endmodule
