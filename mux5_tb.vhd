library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_tb is
end mux_tb;

architecture behv of mux_tb is
	component mux
		generic(n : natural := 5);
		port( x,y: in std_logic_vector(n-1 downto 0);
              sel: in std_logic;
		      z  : out std_logic_vector(n-1 downto 0));
	end component;

	--test signals
    signal sel: std_logic;
	signal x, y, z : std_logic_vector(4 downto 0);
begin

mux_dut : mux port map (x => x, y => y, sel => sel, z => z);

process
     type pattern_type is record
         --  The inputs of the device.
	     x   : std_logic_vector(4 downto 0);
         y   : std_logic_vector(4 downto 0);
         sel : std_logic;
         --  The expected outputs of the device.
         z   : std_logic_vector(4 downto 0);
     end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
         ((X"01", X"00", '0', X"01"),
          (X"00", X"01", '0', X"00"),
          (X"01", X"00", '1', X"00"),
          (X"01", X"01", '1', X"01"),
          (X"01", X"00", '0', X"01"),
          (X"00", X"01", '0', X"00"),
          (X"01", X"00", '1', X"00"),
          (X"01", X"01", '1', X"01"));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         x <= patterns(i).x;
         y <= patterns(i).y;
         sel <= patterns(i).sel;

         --  Wait for the results.
         wait for 1 ns;

         --  Check the outputs.
         assert z = patterns(i).z
            report "bad mux value" severity error;
      end loop;
      assert false report "end of test" severity note;

      --  Wait forever; this will finish the simulation.
      wait;

   end process;
end behv;
