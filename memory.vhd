library ieee;
use ieee.std_logic_1164.all;

entity memory is
	port (clk : in std_logic;

	--control signals in
	RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i : in std_logic;

	--control signals out
	RegWrite_o, MemtoReg_o : out std_logic;

	--datapath in
	reg_write_addr_i : in std_logic_vector(4 downto 0);
	alu_result_i : in std_logic_vector(31 downto 0);
	mem_write_data_i : in std_logic_vector(31 downto 0);

	--datapath out
	reg_write_addr_o : out std_logic_vector(4 downto 0);
	alu_result_o : out std_logic_vector(31 downto 0);
	mem_read_data_o : out std_logic_vector(31 downto 0)

	);
end entity memory;

architecture struc of memory is

	component dmemory is
		port (clk : in std_logic;
	      	  mem_read, mem_write : in std_logic;
	      	  address : in std_logic_vector(31 downto 0);
	      	  write_data : in std_logic_vector(31 downto 0);
	      	  read_data : out std_logic_vector(31 downto 0));
	end component dmemory;

begin

	-- control signal pass through
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;

	-- datapath pass through
	alu_result_o <= alu_result_i;
	reg_write_addr_o <= reg_write_addr_i;

	mips32_dmem : dmemory
		port map(clk        => clk,
				 mem_read   => MemRead_i,
			     mem_write  => MemWrite_i,
			     address    => alu_result_i,
			     write_data => mem_write_data_i,
			     read_data  => mem_read_data_o);

end struc;
