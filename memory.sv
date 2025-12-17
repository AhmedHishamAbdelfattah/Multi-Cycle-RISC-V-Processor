module memory(
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a, wd,
    output logic [31:0] rd
);

    logic [31:0] RAM[63:0];

    initial begin
        RAM[0]  = 32'h00500093; // addi x1, x0, 5
        RAM[1]  = 32'h00A00113; // addi x2, x0, 10
        RAM[2]  = 32'h002081B3; // add x3, x1, x2
        RAM[3]  = 32'h40118233; // sub x4, x3, x1
        RAM[4]  = 32'h0020e2b3; // or x5, x1, x2
        RAM[5]  = 32'h0020f333; // and x6, x1, x2
        RAM[6]  = 32'h00300023; // sw x3, 0(x0)
        RAM[7]  = 32'h00002383; // lw x7, 0(x0)
        RAM[8]  = 32'h0080006F; // j end (PC+8)
        RAM[9]  = 32'h00100413; // addi x8, x0, 1 (skipped by jump)
        RAM[10] = 32'h00900493; // addi x9, x0, 9 (end label)
    end

    // Read logic (word-aligned)
    assign rd = RAM[a[31:2]];

    // Write logic
    always @(posedge clk)
        if (we) RAM[a[31:2]] <= wd;

endmodule
