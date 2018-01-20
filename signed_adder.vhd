library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_adder is
	generic (width : natural := 32);
	port (a, b :  in signed(width-1 downto 0);
	       sum : out signed(width-1 downto 0);
		 overf : out std_logic);
end signed_adder;


architecture rtl of signed_adder is
	signal sum_ext_w, a_ext_w, b_ext_w : signed(width downto 0);
	signal a_sign_bit, b_sign_bit, sum_sign_bit : std_logic;
begin

	a_ext_w <= resize(a, a_ext_w'length);
	a_sign_bit <= a_ext_w(a_ext_w'high);

	b_ext_w <= resize(b, b_ext_w'length);
	b_sign_bit <= b_ext_w(b_ext_w'high);

	sum_ext_w <= a_ext_w + b_ext_w;
	sum_sign_bit <= sum_ext_w(sum_ext_w'high);

	sum <= resize(sum_ext_w, sum'length);

	overf <= (a_sign_bit and b_sign_bit and not sum_sign_bit)
	          or (not a_sign_bit and not b_sign_bit and sum_sign_bit);

end rtl;
