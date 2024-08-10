# program/04_inst/main.S
#
# RISC-V new instructions (and, andi, xor, xori, ori) software test
#

            .text

start:      andi t0, t0, 0     # Clear register t0
            andi t1, t1, 0     # Clear register t1
            andi t2, t2, 0     # Clear register t2
            andi t3, t3, 0     # Clear register t3
            andi t4, t4, 0     # Clear register t4
            andi t5, t5, 0     # Clear register t5
            lui  t0, 100       # Load register t0 with a value
            lui  t1, 200       # Load register t1 with a value
            lui  t3, 58        # Load register t3 with a value
            lui  t4, 0x5C      # Load register t4 with a value
            and  a0, t0, t1    # Logical AND
            xor  a0, t2, t3    # Logical XOR
            xori a0, t4, 0xD6  # Logical XOR-Immediate
            ori  a0, t5, 0xC5  # Logical OR-Immediate