module instrDec (
    input  logic [6:0] op,
    output logic [2:0] immsrc
);

    always_comb begin
        case(op)
            7'b0110011: immsrc = 3'b000; // R-type → no immediate
            7'b0010011: immsrc = 3'b000; // I-type arithmetic (ADDI, SLTI, ORI, ANDI)
            7'b0000011: immsrc = 3'b000; // I-type load
            7'b0100011: immsrc = 3'b001; // S-type store
            7'b1100011: immsrc = 3'b010; // B-type branch
            7'b1101111: immsrc = 3'b011; // J-type jump (JAL)
            7'b1100111: immsrc = 3'b000; // I-type JALR
            default:     immsrc = 3'bx;
        endcase
    end

endmodule
