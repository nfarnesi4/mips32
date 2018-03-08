library ieee;
use ieee.std_logic_1164.all;

entity writeback is
	port (
	--control signals in
	RegWrite_i, MemtoReg_i : in std_logic;

	--control signals out
	RegWrite_o : out std_logic;

	--datapath in
	reg_write_addr_i : in std_logic_vector(4 downto 0);
	alu_result_i : in std_logic_vector(31 downto 0);
	mem_read_data_i : in std_logic_vector(31 downto 0);

	--datapath out
	reg_write_addr_o : out std_logic_vector(4 downto 0);
	reg_write_data_o : out std_logic_vector(31 downto 0)

	);
end entity writeback;

architecture struc of writeback is
begin

	-- control signal pass through
	RegWrite_o <= RegWrite_i;

	--datapath pass through
	reg_write_addr_o <= reg_write_addr_i;

	-- decide where to get the data to write the register with
	reg_write_data_o <= mem_read_data_i when MemtoReg_i = '1' else alu_result_i;

end struc;
