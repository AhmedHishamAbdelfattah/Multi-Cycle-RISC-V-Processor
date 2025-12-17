module ALU(
    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg zero,
    output reg [31:0] ALUResult 
);
	always @(*) begin
		zero = 0;  
		case(ALUControl)
			3'b000: ALUResult = SrcA + SrcB;
			3'b001: ALUResult = SrcA - SrcB;
			3'b010: ALUResult = SrcA & SrcB;
			3'b011: ALUResult = SrcA | SrcB;
			3'b100: ALUResult = (SrcA < SrcB) ? 1 : 0;
			3'b101: begin 
						ALUResult = SrcA - SrcB;
						zero = (SrcA == SrcB);
					end
			default: ALUResult = 32'bx;
		endcase
	end
endmodule
