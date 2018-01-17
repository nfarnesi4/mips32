library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_jump_tb is
end shift_left_2_jump_tb;

architecture rtl of shift_left_2_jump_tb is

	component shift_left_2_jump
		port ( imm :  in std_logic_vector(25 downto 0);
		pc_4msb :  in std_logic_vector(3 downto 0);
		jump_addr : out std_logic_vector(31 downto 0));
	end component;

	--test signals
	signal imm : std_logic_vector(25 downto 0);
	signal pc_4msb : std_logic_vector(3 downto 0);
	signal jump_addr : std_logic_vector(31 downto 0);

begin

dut : shift_left_2_jump port map (imm => imm,
				  pc_4msb => pc_4msb,
				  jump_addr => jump_addr);

    process
      type pattern_type is record
         --  The inputs of the adder.
         imm : std_logic_vector(25 downto 0);
         pc_4msb : std_logic_vector(pc_4msb'high downto pc_4msb'low);
         --  The expected outputs of the adder.
         jump_addr : std_logic_vector(jump_addr'high downto jump_addr'low);
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        (( "00" & X"000004", X"1", X"10000010"),
	 ( "00" & X"000002", X"2", X"20000008"),
	 ( "00" & X"000001", X"3", X"30000004"),
	 ( "00" & X"000000", X"4", X"40000000"),
         ( "00" & X"000000", X"5", X"50000000"));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         imm <= patterns(i).imm;
         pc_4msb <= patterns(i).pc_4msb;
         --  Wait for the results.
         wait for 1 ns;
         --  Check the outputs.
         assert jump_addr = patterns(i).jump_addr
            report "bad jump address" severity error;
      end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end rtl;
