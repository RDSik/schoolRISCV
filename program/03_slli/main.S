# program/03_slli/main.S
#
# RISC-V new instructions (slli, blt) software test
#

            .text

start:      addi a0, zero, 1       # a0 = 1
shift:      slli a0, a0, 1         # a0 = a0 << 1
            blt a0, zero, start    # if a0 < 0 then start
            beq zero, zero, shift  # else shift
