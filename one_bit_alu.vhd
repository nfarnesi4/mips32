library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity one_bit_alu is
port (a, b, a_inv, b_inv, carry_in, less : in std_logic;
      oper : in std_logic_vector(1 downto 0);
      carry_out, result : out std_logic);
end one_bit_alu;

architecture behav of one_bit_alu is

signal a_w, b_w : std_logic := '0';

begin

	a_w <= a when a_inv = '0' else not a;
	b_w <= b when b_inv = '0' else not b;

	carry_out <= (a_w and b_w) or (carry_in and a_w) or (carry_in and b_w);

	process(oper, a_w, b_w, carry_in, less)
	begin
		case oper is
		-- and
		when "00" =>
			result <= a_w and b_w;

		-- or
		when "01" =>
			result <= a_w or b_w;

		-- add
		when "10" =>
			result <= a_w xor b_w xor carry_in;

		-- set on less than
		when "11" =>
			result <= less;

		when others =>
			result <= '0';

		end case;
	end process;

end behav;
