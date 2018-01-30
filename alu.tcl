add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {0000 0ns}
run 100 ns

add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {0001 0ns}
run 100 ns

add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {0010 0ns}
run 100 ns

add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {0110 0ns}
run 100 ns

add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {0111 0ns}
run 100 ns

add_force {/alu32/a} -radix hex {1 0ns}
add_force {/alu32/b} -radix hex {3 0ns}
add_force {/alu32/oper} -radix bin {1100 0ns}
run 100 ns


