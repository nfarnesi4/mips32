add_force {/one_bit_alu/a_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {0 0ns}
add_force {/one_bit_alu/oper} -radix hex {0 0ns}
add_force {/one_bit_alu/a} -radix hex {1 0ns}
add_force {/one_bit_alu/b} -radix hex {1 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns

add_force {/one_bit_alu/a_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {0 0ns}
add_force {/one_bit_alu/oper} -radix hex {1 0ns}
add_force {/one_bit_alu/a} -radix hex {0 0ns}
add_force {/one_bit_alu/b} -radix hex {0 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns

add_force {/one_bit_alu/a_inv} -radix hex {1 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {1 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {0 0ns}
add_force {/one_bit_alu/oper} -radix hex {0 0ns}
add_force {/one_bit_alu/a} -radix hex {0 0ns}
add_force {/one_bit_alu/b} -radix hex {0 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns

add_force {/one_bit_alu/a_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {0 0ns}
add_force {/one_bit_alu/oper} -radix hex {2 0ns}
add_force {/one_bit_alu/a} -radix hex {1 0ns}
add_force {/one_bit_alu/b} -radix hex {1 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns

add_force {/one_bit_alu/a_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {1 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {1 0ns}
add_force {/one_bit_alu/oper} -radix hex {2 0ns}
add_force {/one_bit_alu/a} -radix hex {0 0ns}
add_force {/one_bit_alu/b} -radix hex {1 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns

add_force {/one_bit_alu/a_inv} -radix hex {0 0ns}
add_force {/one_bit_alu/b_inv} -radix hex {1 0ns}
add_force {/one_bit_alu/carry_in} -radix hex {1 0ns}
add_force {/one_bit_alu/oper} -radix hex {3 0ns}
add_force {/one_bit_alu/a} -radix hex {0 0ns}
add_force {/one_bit_alu/b} -radix hex {1 0ns}
add_force {/one_bit_alu/less} -radix hex {0 0ns}
run 100 ns





