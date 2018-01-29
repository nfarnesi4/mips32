library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic (width : natural := 32);
	port (a, b : in std_logic_vector(width-1 downto 0);
	      oper : in std_logic_vector(3 downto 0);

	      result : out std_logic_vector(width-1 downto 0);
	        zero : out std_logic;
	    overflow : out std_logic);
end alu;

architecture rtl of alu is
	component norr
		generic (width : natural := 32);
		port (x : in std_logic_vector(width-1 downto 0);
			  z: out std_logic);
	end component;

	component signed_adder
		generic (width : natural := 32);
		port (a, b :  in signed(width-1 downto 0);
	       	   sum : out signed(width-1 downto 0);
		 	 overf : out std_logic);
	end component;

	signal result_w : std_logic_vector(width-1 downto 0) := (others => '0');

	signal add_res : signed(width-1 downto 0) := (others => '0');
	signal add_overf : std_logic := '0';

	signal b_adder : std_logic_vector(width-1 downto 0) := (others => '0');

begin

	result <= result_w;

	nor32 : norr generic map(width => 32)
				 port map (x => result_w,
				           z => zero);

	-- set the b input to the adder based on add or substract
    b_adder <= b when oper(2) = '0' else std_logic_vector(-signed(b));

	-- adder used for the alu. Used for both add and subtract
	adder : signed_adder
		port map (a => signed(a),
		          b => signed(b_adder),
		          sum => add_res,
		          overf => add_overf);

	process(a, b, oper)
	begin
		case oper is

		-- and
		when "0000" =>
			result_w <= a and b;
			overflow <= '0';

		-- or
		when "0001" =>
			result_w <= a or b;
			overflow <= '0';

		-- add
		when "0010" =>
			result_w <= std_logic_vector(add_res);
			overflow <= add_overf;

		-- subtract
		when "0110" =>
			result_w <= std_logic_vector(add_res);
			overflow <= add_overf;

		-- set on less than
		when "0111" =>

			if signed(a) < signed(b) then
				result_w <= std_logic_vector(to_unsigned(1, result_w'length));
			else
				result_w <= (others => '0');
			end if;

			overflow <= '0';

		-- nor
		when "1100" =>
			result_w <= a nor b;
			overflow <= '0';

		when others =>
		    result_w <= (others => '0');
		    overflow <= '0';

		end case;
	end process;

end rtl;
