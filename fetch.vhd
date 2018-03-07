library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
	port ( clk : in std_logic;
	-- control
	pc_next : in std_logic_vector(31 downto 0);
	-- datapath out
	instr : out std_logic_vector(31 downto 0);
	pc_plus4 : out std_logic_vector(31 downto 0)
	);
end entity fetch;

architecture struc of fetch is

	component PC is
		port (clk : in std_logic;
      	  	  addr_in : in std_logic_vector(31 downto 0);
      	  	  addr_out : out std_logic_vector(31 downto 0));
	end component PC;

	component imemory is
		port ( address : in std_logic_vector(31 downto 0);
	       	   data : out std_logic_vector(31 downto 0));
	end component imemory;

	signal iaddress : std_logic_vector(31 downto 0);
begin

	--instantiate program counter and instruction memory

	mips_pc : pc port map (clk => clk,
						   addr_in => pc_next,
						   addr_out => iaddress);

	mips_imemory : imemory port map (address => iaddress,
									 data => instr);

	-- calculate the next address
	pc_plus4 <= std_logic_vector(signed(iaddress) + to_signed(4, pc_plus4'length));

end struc;
