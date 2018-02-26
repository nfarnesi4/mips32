add_force {/alu_control/ALUOp} -radix bin {10 0ns}
add_force {/alu_control/Funct} -radix hex {24 0ns}
run 100 ns

add_force {/alu_control/Funct} -radix hex {25 0ns}
run 100 ns

add_force {/alu_control/Funct} -radix hex {20 0ns}
run 100 ns

add_force {/alu_control/Funct} -radix hex {22 0ns}
run 100 ns

add_force {/alu_control/Funct} -radix hex {2a 0ns}
run 100 ns

add_force {/alu_control/Funct} -radix hex {00 0ns}
add_force {/alu_control/ALUOp} -radix bin {00 0ns}
run 100 ns

add_force {/alu_control/ALUOp} -radix bin {01 0ns}
run 100 ns

