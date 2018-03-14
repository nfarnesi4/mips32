library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
port (clk : in std_logic;
      addr_in : in std_logic_vector(31 downto 0);
      addr_out : out std_logic_vector(31 downto 0));
end PC;

architecture RTL of PC is
signal reg : std_logic_vector(31 downto 0) := (others => '0');
begin

	process(clk)
		type pc_state is (init, normal);
		variable state : pc_state := init;
	begin
		if rising_edge(clk) then
			case state is

			when init =>
				reg <= (others => '0');
				state := normal;

			when normal =>
				reg <= addr_in;

			when others => null;
			end case;
		end if;
	end process;

	addr_out <= reg;

end RTL;
