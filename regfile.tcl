add_force {/regfile/clk} -radix hex {0 0ns} {1 50000ps} -repeat_every 100000ps
add_force {/regfile/RR1} -radix hex {0 0ns}
add_force {/regfile/RR2} -radix hex {0 0ns}
add_force {/regfile/WR} -radix hex {0 0ns}
add_force {/regfile/RegWrite} -radix hex {0 0ns}
add_force {/regfile/WD} -radix hex {0 0ns}

run 100 ns
add_force {/regfile/RR1} -radix unsigned {18 0ns}
add_force {/regfile/RR2} -radix unsigned {19 0ns}

run 100 ns
add_force {/regfile/RR1} -radix unsigned {19 0ns}
add_force {/regfile/RR2} -radix unsigned {18 0ns}
add_force {/regfile/WR} -radix unsigned {20 0ns}
add_force {/regfile/WD} -radix hex {31 0ns}
add_force {/regfile/RegWrite} -radix hex {1 0ns}

run 100 ns
add_force {/regfile/RR2} -radix unsigned {20 0ns}
add_force {/regfile/RegWrite} -radix hex {0 0ns}

run 100 ns
add_force {/regfile/RR1} -radix unsigned {20 0ns}
add_force {/regfile/RR2} -radix unsigned {20 0ns}
add_force {/regfile/WR} -radix unsigned {0 0ns}
add_force {/regfile/WD} -radix hex {ffffffff 0ns}
add_force {/regfile/RegWrite} -radix hex {1 0ns}

run 100 ns
add_force {/regfile/RR1} -radix unsigned {0 0ns}
add_force {/regfile/RR2} -radix unsigned {0 0ns}
add_force {/regfile/WR} -radix hex {0 0ns}
add_force {/regfile/RegWrite} -radix hex {0 0ns}

run 100 ns
