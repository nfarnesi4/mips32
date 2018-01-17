library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity sign_extend_tb is
end sign_extend_tb;

architecture behv of sign_extend_tb is
    component sign_extend
    	generic (in_width : natural := 15;
    		 out_width : natural := 32);
    	port (x :  in std_logic_vector(in_width-1 downto 0);
    	      y : out std_logic_vector(out_width-1 downto 0));
    end component;

    --test signals
    signal x : std_logic_vector(14 downto 0);
    signal y : std_logic_vector(31 downto 0);

begin

    sign_extend_dut : sign_extend
    port map (x => x,
	      y => y);

    process
      type pattern_type is record
          x : signed(14 downto 0);
          y : signed(31 downto 0);
      end record;

      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
      ((to_signed(-5,15), to_signed(-5, 32)),
       (to_signed(5,15), to_signed(5, 32)),
       (to_signed(4,15), to_signed(4, 32)),
       (to_signed(1,15), to_signed(1, 32)),
       (to_signed(-4,15), to_signed(-4, 32)),
       (to_signed(-3,15), to_signed(-3, 32)));

    begin

    	for i in patterns'range loop
		x <= std_logic_vector(patterns(i).x);

		wait for 1 ns;

		assert y = std_logic_vector(patterns(i).y);
			report "y = " & integer'image(to_integer(signed(y))) severity error;

		wait for 1 ns;
    	end loop;
    	assert false report "end of test" severity note;
    	wait;

    end process;

end behv;

