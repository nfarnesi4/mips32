library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity one_bit_alu is
port (a, b, a_inv, b_inv, carry_in, less : in std_logic;
      oper : in std_logic_vector(3 downto 0);
      carry_out, result : out std_logic);
end one_bit_alu;

architecture behav of one_bit_alu is

signal a_w, b_w : std_logic := '0';

begin

	a_w <= a when a_inv = '0' else not a;
	b_w <= b when b_inv = '0' else not b;

	carry_out <= (a_w and b_w) or (carry_in and a_w) or (carry_in and b_w);

	process
	begin
		case oper is
		-- and
		when "0000" =>
			result <= a_w and b_w;

		-- or
		when "0001" =>
			result <= a_w or b_w;

		-- add
		when "0010" =>
			result <= a_w xor b_w xor carry_in;

		-- substract
		when "0110" =>
			result <= a_w xor b_w xor carry_in;

		-- set on less than
		when "0111" =>
			result <= less;

		-- NOR
		when "1100" =>
			-- or the inputs because a invert and b invert will be set
			result <= a_w or b_w;

		when others =>
			result <= '0';

		end case;
	end process;

end behav;
