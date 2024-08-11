# program/04_inst/main.S
#
# RISC-V new instructions (and, andi, xor, xori, ori, srli, bge) software test
#

            .text

start:      addi a0, zero, 1        # a0 = 1
            and  a1, a0, zero       # a1 = a0 & 0
            or   a2, a0, a1         # a2 = a0 | a1
            xor  a3, a0, a2         # a3 = a0 ^ a2
            andi a0, a1, 0x5C       # a0 = a1 & 0x5C
            ori  a0, a1, 0xC5       # a0 = a1 | 0xC5
            xori a0, a1, 0xD6       # a0 = a1 ^ 0xD6
shift:      srli a0, a0, 1          # a0 = a0 >> 1
            bge  zero, a0, start    # if 0 >= a0 then start
            beq  zero, zero, shift  # else shift
