library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_tb is
end pc_tb;

architecture behv of pc_tb is

    component PC
      port (clk : in std_logic;
            addr_in : in std_logic_vector(31 downto 0);
            addr_out : out std_logic_vector(31 downto 0));
    end component;

    --test signals
    signal clk : std_logic := '0';
    signal addr_in : std_logic_vector(31 downto 0);
    signal addr_out : std_logic_vector(31 downto 0);

begin

    pc_dut : PC
    port map (clk => clk, addr_in => addr_in, addr_out => addr_out);

    process
      type pattern_type is record
         --  The inputs of the device.
         addr_in : std_logic_vector(addr_in'high downto addr_in'low);
         --  The expected outputs of the device.
         addr_out : std_logic_vector(addr_out'high downto addr_out'low);
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        ((X"00000001", X"00000000"),
	 (X"00000002", X"00000001"),
	 (X"00040000", X"00000002"),
	 (X"10000000", X"00040000"),
	 (X"00000000", X"10000000"));
    begin

	wait for 1 ns;
      	for i in patterns'range loop

      	    assert addr_out = patterns(i).addr_out
      	        report "address error" severity error;

      	    addr_in <= patterns(i).addr_in;

      	    wait for 1 ns;
      	    clk <= '1';
      	    wait for 1 ns;
      	    clk <= '0';

      	end loop;

	assert false report "end of test" severity note;
	--  Wait forever; this will finish the simulation.
	wait;

    end process;

end behv;
