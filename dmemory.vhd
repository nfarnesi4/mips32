library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmemory is
	port (clk : in std_logic;
	      mem_read, mem_write : in std_logic;
	      address : in std_logic_vector(31 downto 0);
	      write_data : in std_logic_vector(31 downto 0);
	      read_data : out std_logic_vector(31 downto 0));
end entity dmemory;

architecture rtl of dmemory is
	type byte_mem is array (integer range <>) of std_logic_vector(7 downto 0);
	signal dmem : byte_mem(0 to 255) := (7 => X"04",
	                                     6 => X"00",
	                                     5 => X"00",
	                                     4 => X"00",
	                                     -- 8-11 = 5
	                                     11 => X"05",
	                                     10 => X"00",
	                                     9  => X"00",
	                                     8  => X"00",
	                                     others => (others => '0'));

	signal addr_3, addr_2, addr_1, addr_0 : unsigned(31 downto 0);
begin

	-- calculate the address for each byte in the word given the base addr
	addr_3 <= unsigned(address(31 downto 0)) + 3;
	addr_2 <= unsigned(address(31 downto 0)) + 2;
	addr_1 <= unsigned(address(31 downto 0)) + 1;
	addr_0 <= unsigned(address(31 downto 0));

-- for whatever reason this breaks everything
--	initlize_dmem : process(clk, address, write_data, mem_read, mem_write)
--		variable initlized : boolean := false;
--	begin
--		if not initlized then
--			-- 4-7 = 4
--			dmem <= (7 => X"00",
--			         6 => X"00",
--			         5 => X"00",
--			         4 => X"04",
--			         -- 8-11 = 5
--			         11 => X"00",
--			         10 => X"00",
--			         9  => X"00",
--			         8  => X"05",
--					others => (others => '0'));

--			initlized := true;
--		end if;
--	end process;

	write : process(clk)
	begin
		if rising_edge(clk) then
			if mem_read = '0' and mem_write = '1' then
				dmem(to_integer(addr_0)) <=	write_data(31 downto 24);
				dmem(to_integer(addr_1)) <=	write_data(23 downto 16);
				dmem(to_integer(addr_2)) <=	write_data(15 downto 8);
				dmem(to_integer(addr_3)) <=	write_data( 7 downto 0);
			end if;
		end if;
	end process;

	read : process(clk)
	begin
		if falling_edge(clk) then
			if mem_read = '1' and mem_write = '0' then
				read_data <= dmem(to_integer(addr_0)) & dmem(to_integer(addr_1)) &
			        	     dmem(to_integer(addr_2)) & dmem(to_integer(addr_3));
			else
				read_data <= (others => '0');
			end if;
		end if;
	end process;

end rtl;
