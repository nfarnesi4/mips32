library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andd_tb is
end andd_tb;

architecture behv of andd_tb is

	component andd
    	    generic ( n: natural := 32 );
    	    port ( x,y: in std_logic_vector(n-1 downto 0);
           	   z: out std_logic_vector(n-1 downto 0) );
	end component;

	--test signals
	signal z, x, y : std_logic_vector(0 downto 0);

begin

andd_dut : andd
      generic map (n => 1)
      port map (x => x,
		y => y,
		z => z);
    process
      type pattern_type is record
         --  The inputs of the device.
	 x : std_logic_vector(0 downto 0);
	 y : std_logic_vector(0 downto 0);
         --  The expected outputs of the device.
	 z : std_logic_vector(0 downto 0);
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        (("0", "0", "0"),
	 ("1", "0", "0"),
	 ("0", "1", "0"),
         ("1", "1", "1"));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         x <= patterns(i).x;
         y <= patterns(i).y;
         --  Wait for the results.
         wait for 1 ns;
         --  Check the outputs.
         assert z = patterns(i).z
            report "bad shifted value" severity error;
      end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end behv;
