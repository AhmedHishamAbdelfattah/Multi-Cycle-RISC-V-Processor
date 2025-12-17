`timescale 1ns/1ps

module TB_RISCV_MultiCycle();

    reg clk;
    reg reset;

    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire MemWrite;
    wire [31:0] ReadData;  // connected internally by memory in your design
    integer k, m;

	// assign ReadData = dut.ReadData ; 


    // Instantiate the top-level multi-cycle processor + memory
    top_multi_cycle dut (
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );

    // =================================================================
    // Clock generation (period = 10ns)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Reset pulse
    initial begin
        reset = 1'b1;
        #20;
        reset = 1'b0;
    end

    // =================================================================
    // Debug monitor — print internal signals every clock cycle
    // You might need to adjust signals depending on your module internals.
    always @(posedge clk) begin
        #1;  // small delay for stable signals

        $display("\n========================================================");
        $display(" Cycle @ %0t", $time);
        $display("========================================================");

        $display(" MemWrite   = %b", dut.rvMulti.c.memwrite);
        $display(" PC         = %h", dut.rvMulti.dp.PC);
        $display(" Instr      = %h", dut.rvMulti.dp.instr);

        $display(" opcode=%b funct3=%b funct7=%b",
            dut.rvMulti.dp.instr[6:0],
            dut.rvMulti.dp.instr[14:12],
            dut.rvMulti.dp.instr[30]
        );

        $display(" rs1=%0d rs2=%0d rd=%0d",
            dut.rvMulti.dp.instr[19:15],
            dut.rvMulti.dp.instr[24:20],
            dut.rvMulti.dp.instr[11:7]
        );

        $display("--------------------------------------------------------");
        $display(" CONTROL:");
        $display("  RegWrite   = %b", dut.rvMulti.c.regwrite);
        $display("  MemWrite   = %b", dut.rvMulti.c.memwrite);
        $display("  ALUSrcA    = %b", dut.rvMulti.c.alusrca);
        $display("  ALUSrcB    = %b", dut.rvMulti.c.alusrcb);
        $display("  ResultSrc  = %b", dut.rvMulti.c.resultsrc);
        $display("  ImmSrc     = %b", dut.rvMulti.c.immsrc);
        $display("  ALUControl = %b", dut.rvMulti.c.alucontrol);
        $display("  irwrite    = %b", dut.rvMulti.c.irwrite);
        $display("  pcwrite    = %b", dut.rvMulti.c.pcwrite);

        $display("--------------------------------------------------------");
        $display(" DATAPATH:");
        $display("  ALUResult  = %h", dut.rvMulti.dp.ALUResult);
        $display("  Zero       = %b", dut.rvMulti.dp.Zero);
        $display("  Adr        = %h", dut.DataAdr);
        $display("  WriteData  = %h", dut.WriteData);
        $display("  ReadData   = %h", dut.ReadData);

        $display("--------------------------------------------------------");
        $display(" REGISTER FILE (x0 to x9):");
        for (k = 0; k < 10; k = k + 1) begin
            $display("  x%0d = %h", k, dut.rvMulti.dp.rf.regf[k]);
        end

        $display("--------------------------------------------------------");
        $display(" DATA MEMORY [0..7]:");
        for (m = 0; m < 25; m = m + 1) begin
            $display("  mem[%0d] = %h", m, dut.mem.RAM[m]);
        end

        $display("========================================================");
    end

    // =================================================================
    // Simulation stop and check correctness
    initial begin
        // Run simulation for enough time
        #500;

        // Check expected results after running your sample program
        if (dut.rvMulti.dp.rf.regf[3] == 15 &&
            dut.rvMulti.dp.rf.regf[7] == 15 &&
            dut.rvMulti.dp.rf.regf[9] == 9) 
        begin
            $display("\n====================================================");
            $display("               SIMULATION SUCCESSFUL");
            $display("====================================================");
        end else begin
            $display("\n====================================================");
            $display("               SIMULATION FAILED");
            $display(" x3 = %d  x7 = %d  x9 = %d", 
                      dut.rvMulti.dp.rf.regf[3],
                      dut.rvMulti.dp.rf.regf[7],
                      dut.rvMulti.dp.rf.regf[9]);
            $display("====================================================");
        end

        $stop;
    end

endmodule
