module fsm (
    input  logic        clk, rst,
    input  logic [6:0]  op,
    output logic        branch, pcupdate, regwrite, memwrite, irwrite,
    output logic [1:0]  resultsrc, alusrcb, alusrca,
    output logic        adrsrc,
    output logic [1:0]  aluop
);

    // s11 = ERROR / DEFAULT STATE
    typedef enum logic [3:0] {
        s0, s1, s2, s3,
        s4, s5, s6, s7,
        s8, s9, s10,
        s11
    } statetype;

    statetype state, nextstate;

    //========================================
    // State Register
    //========================================
    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            state <= s0;
        else
            state <= nextstate;
    end

    //========================================
    // Next-State Logic
    //========================================
    always_comb begin
        case (state)

            s0: nextstate = s1;

            s1: case (op)
                    7'b0110011: nextstate = s6;
                    7'b0010011: nextstate = s8;
                    7'b0000011: nextstate = s2;
                    7'b0100011: nextstate = s2;
                    7'b1100011: nextstate = s10;
                    7'b1101111: nextstate = s9;
                    7'b1100111: nextstate = s2;
                    default:    nextstate = s11; // ERROR
                endcase

            s2: if (op[5]) begin
                    if (op[6])
                        nextstate = s9;
                    else
                        nextstate = s5;
                end
                else
                    nextstate = s3;

            s3:  nextstate = s4;
            s4:  nextstate = s0;
            s5:  nextstate = s0;
            s6:  nextstate = s7;
            s7:  nextstate = s0;
            s8:  nextstate = s7;
            s9:  nextstate = s7;
            s10: nextstate = s0;

            // ERROR STATE (self-loop)
            s11: nextstate = s11;

        endcase
    end

    //========================================
    // Output Logic
    //========================================
    always_comb begin
        case (state)

            s0: begin
                branch    = 1'b0;
                pcupdate  = 1'b1;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b1;
                resultsrc = 2'b10;
                alusrcb   = 2'b10;
                alusrca   = 2'b00;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s1: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b01;
                alusrca   = 2'b01;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s2: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b01;
                alusrca   = 2'b10;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s3: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b00;
                alusrca   = 2'b00;
                adrsrc    = 1'b1;
                aluop     = 2'b00;
            end

            s4: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b1;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b01;
                alusrcb   = 2'b00;
                alusrca   = 2'b00;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s5: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b1;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b00;
                alusrca   = 2'b00;
                adrsrc    = 1'b1;
                aluop     = 2'b00;
            end

            s6: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b00;
                alusrca   = 2'b10;
                adrsrc    = 1'b0;
                aluop     = 2'b10;
            end

            s7: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b1;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b00;
                alusrca   = 2'b00;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s8: begin
                branch    = 1'b0;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b01;
                alusrca   = 2'b10;
                adrsrc    = 1'b0;
                aluop     = 2'b10;
            end

            s9: begin
                branch    = 1'b0;
                pcupdate  = 1'b1;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b10;
                alusrca   = 2'b01;
                adrsrc    = 1'b0;
                aluop     = 2'b00;
            end

            s10: begin
                branch    = 1'b1;
                pcupdate  = 1'b0;
                regwrite  = 1'b0;
                memwrite  = 1'b0;
                irwrite   = 1'b0;
                resultsrc = 2'b00;
                alusrcb   = 2'b00;
                alusrca   = 2'b10;
                adrsrc    = 1'b0;
                aluop     = 2'b01;
            end

            // ERROR / DEFAULT STATE
            s11: begin
                branch    = 1'bx;
                pcupdate  = 1'bx;
                regwrite  = 1'bx;
                memwrite  = 1'bx;
                irwrite   = 1'bx;
                resultsrc = 2'bx;
                alusrcb   = 2'bx;
                alusrca   = 2'bx;
                adrsrc    = 1'bx;
                aluop     = 2'bx;
            end

        endcase
    end

endmodule
