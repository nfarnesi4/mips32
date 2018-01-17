library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_tb is
end shift_left_2_tb;

architecture behv of shift_left_2_tb is

	component shift_left_2
		generic(width : natural := 32);
		port( x :  in std_logic_vector(width-1 downto 0);
		      y : out std_logic_vector(width-1 downto 0));
	end component;

	--test signals
	signal x, y : std_logic_vector(31 downto 0);

begin

shift_left_2_dut : shift_left_2
      port map (x => x,
		y => y);
    process
      type pattern_type is record
         --  The inputs of the device.
	 x : std_logic_vector(31 downto 0);
         --  The expected outputs of the device.
	 y : std_logic_vector(31 downto 0);
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        ((X"00000001", X"00000004"),
	 (X"00000004", X"00000010"),
	 (X"00000010", X"00000040"),
	 (X"00000200", X"00000800"),
         (X"01000000", X"04000000"));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         x <= patterns(i).x;
         --  Wait for the results.
         wait for 1 ns;
         --  Check the outputs.
         assert y = patterns(i).y
            report "bad shifted value" severity error;
      end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end behv;
