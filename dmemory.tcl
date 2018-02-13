add_force {/dmemory/clk} -radix hex {0 0ns} {1 50000ps} -repeat_every 100000ps
add_force {/dmemory/mem_read} -radix hex {0 0ns}
add_force {/dmemory/mem_write} -radix hex {0 0ns}
add_force {/dmemory/address} -radix hex {0 0ns}
add_force {/dmemory/write_data} -radix hex {0 0ns}
run 125 ns

add_force {/dmemory/mem_read} -radix hex {1 0ns}
add_force {/dmemory/mem_write} -radix hex {0 0ns}
add_force {/dmemory/address} -radix hex {4 0ns}
run 100 ns

add_force {/dmemory/mem_read} -radix hex {0 0ns}
add_force {/dmemory/mem_write} -radix hex {1 0ns}
add_force {/dmemory/address} -radix hex {10 0ns}
add_force {/dmemory/write_data} -radix unsigned {777 0ns}
run 100 ns

add_force {/dmemory/mem_read} -radix hex {1 0ns}
add_force {/dmemory/mem_write} -radix hex {0 0ns}
add_force {/dmemory/address} -radix hex {10 0ns}
run 100 ns
