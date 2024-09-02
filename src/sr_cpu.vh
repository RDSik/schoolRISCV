/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

`ifndef SR_CPU_VH
`define SR_CPU_VH

//ALU commands
`define ALU_ADD     4'b0000
`define ALU_OR      4'b0001
`define ALU_SRL     4'b0010
`define ALU_SLTU    4'b0011
`define ALU_SUB     4'b0100
`define ALU_SLL     4'b0101
`define ALU_AND     4'b0111
`define ALU_XOR     4'b1000

// ALU source B control signal encoding
 `define SRC_B_RD2   2'b00
 `define SRC_B_IMM_I 2'b01
 `define SRC_B_IMM_S 2'b10

// instruction opcode
`define RVOP_SW     7'b0100011
`define RVOP_ADD    7'b0110011
`define RVOP_AND    7'b0110011
`define RVOP_OR     7'b0110011
`define RVOP_XOR    7'b0110011
`define RVOP_SRL    7'b0110011
`define RVOP_SLL    7'b0110011
`define RVOP_SLTU   7'b0110011
`define RVOP_SUB    7'b0110011
`define RVOP_ADDI   7'b0010011
`define RVOP_ANDI   7'b0010011
`define RVOP_ORI    7'b0010011
`define RVOP_XORI   7'b0010011
`define RVOP_SLLI   7'b0010011
`define RVOP_SRLI   7'b0010011
`define RVOP_BEQ    7'b1100011
`define RVOP_BNE    7'b1100011
`define RVOP_BLT    7'b1100011
`define RVOP_BGE    7'b1100011
`define RVOP_LUI    7'b0110111

// instruction funct3
`define RVF3_SW     3'b010
`define RVF3_ADD    3'b000
`define RVF3_ADDI   3'b000
`define RVF3_AND    3'b111
`define RVF3_ANDI   3'b111
`define RVF3_XOR    3'b100
`define RVF3_XORI   3'b100
`define RVF3_OR     3'b110
`define RVF3_ORI    3'b110
`define RVF3_SRL    3'b101
`define RVF3_SRLI   3'b101
`define RVF3_SLL    3'b001
`define RVF3_SLLI   3'b001
`define RVF3_SLTU   3'b011
`define RVF3_SUB    3'b000
`define RVF3_ANY    3'b???
`define RVF3_BEQ    3'b000
`define RVF3_BNE    3'b001
`define RVF3_BLT    3'b100
`define RVF3_BGE    3'b101

// instruction funct7
`define RVF7_ADD    7'b0000000
`define RVF7_AND    7'b0000000
`define RVF7_XOR    7'b0000000
`define RVF7_OR     7'b0000000
`define RVF7_SRL    7'b0000000
`define RVF7_SLL    7'b0000000
`define RVF7_SLLI   7'b0000000
`define RVF7_SRLI   7'b0000000
`define RVF7_SLTU   7'b0000000
`define RVF7_SUB    7'b0100000
`define RVF7_ANY    7'b???????

`endif  // `ifndef SR_CPU_VH
