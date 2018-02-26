library ieee;
use ieee.std_logic_1164.all;

entity alu_control is
	port (ALUOp : in std_logic_vector(1 downto 0);
	      Funct : in std_logic_vector(5 downto 0);
	      Operation : out std_logic_vector(3 downto 0)
	);
end entity alu_control;

architecture rtl of alu_control is
begin

	process(ALUOp)
	begin
		case ALUOp is
		-- lw, sw, or jump set the alu to add
		when "00" =>
			Operation <= "0010";
		-- branch, set the alu to subtract
		when "01" =>
			Operation <= "0110";
		-- r type set the alu based on Funct
		when "10" =>
			case Funct is
			-- and
			when "100100" =>
				Operation <= "0000";
			-- or
			when "100101" =>
				Operation <= "0001";
			-- add
			when "100000" =>
				Operation <= "0010";
			-- sub
			when "100010" =>
				Operation <= "0110";
			-- slt
			when "101010" =>
				Operation <= "0111";
			when others =>
				Operation <= "----";
			end case;
		when others => NULL;
		end case;
	end process;

end rtl;
