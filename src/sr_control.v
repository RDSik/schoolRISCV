/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

`include "sr_cpu.vh"

module sr_control
(
    input     [ 6:0] cmdOp,
    input     [ 2:0] cmdF3,
    input     [ 6:0] cmdF7,
    input            aluZero,
    output           pcSrc,
    output reg       regWrite,
    output reg [1:0] aluSrc,
    output reg       wdSrc,
    output reg       memWrite,
    output reg [3:0] aluControl
);
    reg          branch;
    reg          condZero;
    assign pcSrc = branch & (aluZero == condZero);

    always @ (*) begin
        branch      = 1'b0;
        condZero    = 1'b0;
        regWrite    = 1'b0;
        aluSrc      = `SRC_B_RD2;
        wdSrc       = 1'b0;
        memWrite    = 1'b0;
        aluControl  = `ALU_ADD;

        casez( {cmdF7, cmdF3, cmdOp} )
            { `RVF7_ADD,  `RVF3_ADD,  `RVOP_ADD  } : begin regWrite = 1'b1; aluControl = `ALU_ADD;  end
            { `RVF7_OR,   `RVF3_OR,   `RVOP_OR   } : begin regWrite = 1'b1; aluControl = `ALU_OR;   end
            { `RVF7_SRL,  `RVF3_SRL,  `RVOP_SRL  } : begin regWrite = 1'b1; aluControl = `ALU_SRL;  end
            { `RVF7_SLTU, `RVF3_SLTU, `RVOP_SLTU } : begin regWrite = 1'b1; aluControl = `ALU_SLTU; end
            { `RVF7_SUB,  `RVF3_SUB,  `RVOP_SUB  } : begin regWrite = 1'b1; aluControl = `ALU_SUB;  end
            { `RVF7_AND,  `RVF3_AND,  `RVOP_AND  } : begin regWrite = 1'b1; aluControl = `ALU_AND;  end
            { `RVF7_SLL,  `RVF3_SLL,  `RVOP_SLL  } : begin regWrite = 1'b1; aluControl = `ALU_SLL;  end
            { `RVF7_XOR,  `RVF3_XOR,  `RVOP_XOR  } : begin regWrite = 1'b1; aluControl = `ALU_XOR;  end    

            { `RVF7_SLLI, `RVF3_SLLI, `RVOP_SLLI } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_SLL; end
            { `RVF7_SRLI, `RVF3_SRLI, `RVOP_SRLI } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_SRL; end
            { `RVF7_ANY,  `RVF3_ADDI, `RVOP_ADDI } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_ADD; end
            { `RVF7_ANY,  `RVF3_ANDI, `RVOP_ANDI } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_AND; end
            { `RVF7_ANY,  `RVF3_XORI, `RVOP_XORI } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_XOR; end
            { `RVF7_ANY,  `RVF3_ORI,  `RVOP_ORI  } : begin regWrite = 1'b1; aluSrc = `SRC_B_IMM_I; aluControl = `ALU_OR;  end                
            { `RVF7_ANY,  `RVF3_ANY,  `RVOP_LUI  } : begin regWrite = 1'b1; wdSrc  = 1'b1; end

            { `RVF7_ANY,  `RVF3_BEQ,  `RVOP_BEQ  } : begin branch = 1'b1; condZero = 1'b1; aluControl = `ALU_SUB; end
            { `RVF7_ANY,  `RVF3_BGE,  `RVOP_BGE  } : begin branch = 1'b1; condZero = 1'b1; aluControl = `ALU_SUB; end
            { `RVF7_ANY,  `RVF3_BNE,  `RVOP_BNE  } : begin branch = 1'b1; aluControl = `ALU_SUB; end
            { `RVF7_ANY,  `RVF3_BLT,  `RVOP_BLT  } : begin branch = 1'b1; aluControl = `ALU_SUB; end
            { `RVF7_ANY,  `RVF3_SW,   `RVOP_SW   } : begin memWrite = 1'b1; aluSrc = `SRC_B_IMM_S; aluControl = `ALU_ADD; end
            { `RVF7_ANY,  `RVF3_SH,   `RVOP_SH   } : begin memWrite = 1'b1; aluSrc = `SRC_B_IMM_S; aluControl = `ALU_ADD; end
            { `RVF7_ANY,  `RVF3_SB,   `RVOP_SB   } : begin memWrite = 1'b1; aluSrc = `SRC_B_IMM_S; aluControl = `ALU_ADD; end
        endcase
    end
endmodule
