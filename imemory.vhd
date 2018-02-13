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
			imem <= (0 => X"00",
			         1 => X"01",
			         2 => X"02",
			         3 => X"03",
			         -- instruction
			         4 => X"FF",
			         5 => X"FF",
			         6 => X"FF",
			         7 => X"FF",
					others => (others => '0'));

			initlized := true;
		end if;
	end process;


	data <= imem(to_integer(addr_3)) & imem(to_integer(addr_2)) &
			imem(to_integer(addr_1)) & imem(to_integer(addr_0));

end rtl;

