library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
	port (clk : in std_logic;
	      RR1, RR2, WR : in std_logic_vector(4 downto 0);
		  RegWrite : in std_logic;
	      WD       : in std_logic_vector(31 downto 0);
	      RD1, RD2 : out std_logic_vector(31 downto 0));
end entity regfile;

architecture rtl of regfile is
	type reg_file is array (integer range <>) of std_logic_vector(31 downto 0);
	signal regs : reg_file(1 to 31) := ( 8 => X"00000004",
	                                    18 => X"0000000D",
	                                    19 => X"00000004",
	                                    others => (others => '0'));
begin

	process (clk)
	begin
		if rising_edge(clk) then

			-- write to the register if it is regwrite is enabled
			if RegWrite = '1' then
				-- do not write to reg zero
				if to_integer(unsigned(WR)) /= 0 then
					regs(to_integer(unsigned(WR))) <= WD;
				end if;
			end if;

		end if;

		if falling_edge(clk) then

			-- set the regfile ouputs
			if to_integer(unsigned(RR1)) = 0 then
				RD1 <= (others => '0');
			else
				RD1 <= regs(to_integer(unsigned(RR1)));
			end if;

			if to_integer(unsigned(RR2)) = 0 then
				RD2 <= (others => '0');
			else
				RD2 <= regs(to_integer(unsigned(RR2)));
			end if;

		end if;

	end process;
end rtl;

