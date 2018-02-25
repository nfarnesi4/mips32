library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imemory is
	port ( address : in std_logic_vector(31 downto 0);
	       data : out std_logic_vector(31 downto 0));
end entity imemory;

architecture rtl of imemory is
	type byte_mem is array (integer range <>) of std_logic_vector(7 downto 0);
	signal imem : byte_mem(0 to 255) := (others => (others => '0'));
	signal addr_3, addr_2, addr_1, addr_0 : unsigned(31 downto 0);
begin

	-- calculate the address for each byte in the word given the base addr
	addr_3 <= unsigned(address(31 downto 0)) + 3;
	addr_2 <= unsigned(address(31 downto 0)) + 2;
	addr_1 <= unsigned(address(31 downto 0)) + 1;
	addr_0 <= unsigned(address(31 downto 0));

	load_imem : process(address)
		variable initlized : boolean := false;
	begin
		if not initlized then
			imem <= (
			         -- lw $s5 0($0)
					 0 => X"8d", 1 => X"15", 2 => X"00", 3 => X"00",
			         -- lw $s6, 4($t0)
					 4 => X"8d", 5 => X"16", 6 => X"00", 7 => X"04",
			         -- slt $t7, $s5, $s6
			         8 => X"02", 9 => X"b6", 10 => X"78", 11 => X"2a",
			         -- beq $t7, $s5, $s6
			         12 => X"11", 13 => X"e0", 14 => X"00", 15 => X"02",
			         -- sub $s1, $s2, $s3
			         16 => X"02", 17 => X"53", 18 => X"88", 19 => X"22",
			         -- j exit
			         20 => X"08", 21 => X"00", 22 => X"00", 23 => X"07",
			         -- add $s1, $s2, $s3
			         24 => X"02", 25 => X"53", 26 => X"88", 27 => X"20",
			         -- exit: sw $s1, 12($t0)
			         28 => X"ad", 29 => X"11", 30 => X"00", 31 => X"0c",
			         -- set the rest to noop
					 others => (others => '0'));
			initlized := true;
		end if;
	end process;


	data <= imem(to_integer(addr_0)) & imem(to_integer(addr_1)) &
			imem(to_integer(addr_2)) & imem(to_integer(addr_3));

end rtl;

