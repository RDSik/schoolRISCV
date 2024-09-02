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

module sr_cpu
(
    input           clk,        // clock
    input           rst_n,      // reset
    input   [ 4:0]  regAddr,    // debug access reg address
    output  [31:0]  regData,    // debug access reg data
    output          im_req,     // Instruction memory request
    output  [31:0]  imAddr,     // instruction memory address
    input   [31:0]  imData,     // instruction memory data
    input           im_drdy,
    output  [31:0]  addr_o,     // data memory address
    output  [31:0]  data_o,     // data memory data
    output          memWrite_o  // data memory write request
);
    //control wires
    wire        aluZero;
    wire        pcSrc;
    wire        regWrite;
    wire  [1:0] aluSrc;
    wire        wdSrc;
    wire  [3:0] aluControl;
    wire rfUpd;

    //instruction decode wires
    wire [ 6:0] cmdOp;
    wire [ 4:0] rd;
    wire [ 2:0] cmdF3;
    wire [ 4:0] rs1;
    wire [ 4:0] rs2;
    wire [ 6:0] cmdF7;
    wire [31:0] immI;
    wire [31:0] immS;
    wire [31:0] immB;
    wire [31:0] immU;

    //program counter
    wire [31:0] pc;
    wire [31:0] pcBranch = pc + immB;
    wire [31:0] pcPlus4  = pc + 4;
    wire [31:0] pcNext   = pcSrc ? pcBranch : pcPlus4;
    sm_register_we r_pc(clk ,rst_n, im_drdy, pcNext, pc);

    // PWRON detect
    reg d1;
    reg d2;
    wire pwron;

    always @(posedge clk or negedge rst_n)
    if (~rst_n) begin
        d1 <= 1;
        d2 <= 1;
    end else begin
        d1 <= 0;
        d2 <= d1;
    end

    assign pwron = ~d1 & d2;

    //program memory access
    assign imAddr = im_drdy ? (pcNext >> 2) : (pc >> 2);
    assign im_req = im_drdy | pwron;

    wire [31:0] instr = imData;

    //instruction decode
    sr_decode id (
        .instr      ( instr        ),
        .cmdOp      ( cmdOp        ),
        .rd         ( rd           ),
        .cmdF3      ( cmdF3        ),
        .rs1        ( rs1          ),
        .rs2        ( rs2          ),
        .cmdF7      ( cmdF7        ),
        .immI       ( immI         ),
        .immS       ( immS         ),
        .immB       ( immB         ),
        .immU       ( immU         )
    );

    //register file
    wire [31:0] rd0;
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] wd3;
    assign rfUpd = regWrite & im_drdy;

    sm_register_file rf (
        .clk        ( clk          ),
        .a0         ( regAddr      ),
        .a1         ( rs1          ),
        .a2         ( rs2          ),
        .a3         ( rd           ),
        .rd0        ( rd0          ),
        .rd1        ( rd1          ),
        .rd2        ( rd2          ),
        .wd3        ( wd3          ),
        .we3        ( rfUpd        )
    );



    //debug register access
    assign regData = (regAddr != 0) ? rd0 : pc;

    //alu
    reg  [31:0] srcB;
    wire [31:0] aluResult;

    //selects source B for ALU
    always @(*)
        case (aluSrc)
            `SRC_B_IMM_I: srcB = immI;
            `SRC_B_IMM_S: srcB = immS;
            default:      srcB = rd2;
        endcase

    sr_alu alu (
        .srcA       ( rd1          ),
        .srcB       ( srcB         ),
        .oper       ( aluControl   ),
        .zero       ( aluZero      ),
        .result     ( aluResult    )
    );

    assign wd3 = wdSrc ? immU : aluResult;

    //control
    sr_control sm_control (
        .cmdOp      ( cmdOp        ),
        .cmdF3      ( cmdF3        ),
        .cmdF7      ( cmdF7        ),
        .aluZero    ( aluZero      ),
        .pcSrc      ( pcSrc        ),
        .regWrite   ( regWrite     ),
        .aluSrc     ( aluSrc       ),
        .wdSrc      ( wdSrc        ),
        .memWrite   ( memWrite_o   ),
        .aluControl ( aluControl   )
    );

    // access to data memory
    assign addr_o = aluResult;
    assign data_o = rd2;

endmodule
