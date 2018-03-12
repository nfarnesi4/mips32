library ieee;
use ieee.std_logic_1164.all;

entity mips32_top is
end entity mips32_top;

architecture struc of mips32_top is

	-- modules for each of the cpu stages

	component fetch is
		port ( clk : in std_logic;
		-- control
		pc_next_i : in std_logic_vector(31 downto 0);
		-- datapath out
		instr_o : out std_logic_vector(31 downto 0);
		pc_plus4_o : out std_logic_vector(31 downto 0)
		);
	end component fetch;

	component decode is
		port (clk : in std_logic;

		--control signals in
		RegWrite_i : in std_logic;

		--control signals out
		Branch_o, MemRead_o, MemtoReg_o : out std_logic;
		ALUSrc_o, RegWrite_o, MemWrite_o, jump_o  : out std_logic;
		ALUOp_o : out std_logic_vector(3 downto 0);

		--datapath in
		instr_i : in std_logic_vector(31 downto 0);
		reg_write_addr_i : in std_logic_vector(4 downto 0);
		reg_write_data_i : in std_logic_vector(31 downto 0);
		pc_plus4_i : in std_logic_vector(31 downto 0);

		--datapath out
		RD1_o, RD2_o : out std_logic_vector(31 downto 0);
		reg_write_addr_o : out std_logic_vector(4 downto 0);
		signextend_imm_o : out std_logic_vector(31 downto 0);
		jump_addr_o : out std_logic_vector(31 downto 0);
		pc_plus4_o : out std_logic_vector(31 downto 0)
		);

	component memory is
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
	end component memory;


	component writeback is
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
	end component writeback;


	signal clk : std_logic := '0';

begin

	-- clock generator
	clk_gen : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;

end struc;

