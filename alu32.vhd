library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu32 is
generic (n : natural := 32);
port (a, b : in std_logic_vector(n-1 downto 0);
	  oper : in std_logic_vector(3 downto 0);
	  result : out std_logic_vector(n-1 downto 0);
	    zero : out std_logic;
	   overf : out std_logic
	 );
end alu32;

architecture struc of alu32 is

	component one_bit_alu is
		port (a, b, a_inv, b_inv, carry_in, less : in std_logic;
      	  	  oper : in std_logic_vector(1 downto 0);
      	  	  carry_out, result : out std_logic);
	end component;

	component norr is
    	generic (width : natural := 32);
    	port (x : in std_logic_vector(width-1 downto 0);
          	  z: out std_logic);
	end component;

	-- inversion signals
	signal a_inv, b_inv : std_logic := '0';

	-- less wire
	signal less : std_logic := '0';

	-- connection wires
	signal carry_wires : std_logic_vector(n downto 0) := (others => '0');
	signal result_wires : std_logic_vector(n-1 downto 0) := (others => '0');

begin

	-- wire a and invert to the two MSB bits of the operation
	a_inv <= oper(3);
	b_inv <= oper(2);

	-- connect the input carry to b negate for subtraction
	carry_wires(0) <= b_inv;

	-- slt calculation (basically add the last bits)
	less <= a(n-1) xor not b(n-1) xor carry_wires(n-1) xor (carry_wires(n-1) xor carry_wires(n));

	-- overflow calculation
	overf <= carry_wires(n) xor carry_wires(n-1);

	result <= result_wires;

	nor32 : norr
		generic map (width => 32)
		port map (x => result_wires,
		          z => zero);

	alu_gen : for i in 0 to n-1 generate

		-- the lsb alu is the only one that has the less signal connected
		alu_lsb : if i=0 generate
			alu_0 : one_bit_alu
			port map (a => a(i),
			          b => b(i),
			          a_inv => a_inv,
			          b_inv => b_inv,
			          carry_in => carry_wires(i),
			          less => less,
			          oper => oper(1 downto 0),
			          carry_out => carry_wires(i+1),
			          result => result_wires(i)
					 );
		end generate alu_lsb;

		-- all other alu blocks have less set to zero
		alu_others : if i>0 generate
			alu_x : one_bit_alu
			port map (a => a(i),
			          b => b(i),
			          a_inv => a_inv,
			          b_inv => b_inv,
			          carry_in => carry_wires(i),
			          less => '0',
			          oper => oper(1 downto 0),
			          carry_out => carry_wires(i+1),
			          result => result_wires(i)
					 );
		end generate alu_others;

	end generate;

end struc;
