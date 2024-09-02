/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

module cycle_counter (
    input             clk,
    input             rst_n,
    input             en_i,
    input             clear_i,
    output reg [31:0] cycleCnt_o
);

wire [31:0] cycleCnt_next;

assign cycleCnt_next = clear_i ? 32'd0 : (en_i ? cycleCnt_o + 32'd1 : cycleCnt_o);

// cycle counter
always @(posedge clk or negedge rst_n)
    if (~rst_n) cycleCnt_o <= 32'd0;
    else        cycleCnt_o <= cycleCnt_next;

endmodule