library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
	port (clk : in std_logic;

	--control signals in
	Branch_i, MemRead_i, MemtoReg_i : in std_logic;
	ALUSrc_i, RegWrite_i, MemWrite_i, jump_i  : in std_logic;
	ALUOp_i : in std_logic_vector(3 downto 0);

	--control signals out
	RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o : out std_logic;

	--datapath in
	RD1_i, RD2_i : in std_logic_vector(31 downto 0);
	reg_write_addr_i : in std_logic_vector(4 downto 0);
	signextend_imm_i : in std_logic_vector(31 downto 0);
	jump_addr_i : in std_logic_vector(31 downto 0);
	pc_plus4_i : in std_logic_vector(31 downto 0);

	--datapath out
	reg_write_addr_o : out std_logic_vector(4 downto 0);
	mem_write_data_o : out std_logic_vector(31 downto 0);
	alu_result_o : out std_logic_vector(31 downto 0);
	pc_next_o : out std_logic_vector(31 downto 0)
	);
end entity execute;

architecture struc of execute is


	component alu32 is
		generic (n : natural := 32);
		port (a, b : in std_logic_vector(n-1 downto 0);
	  	  	  oper : in std_logic_vector(3 downto 0);
	  	  	  result : out std_logic_vector(n-1 downto 0);
	    		zero : out std_logic;
	   	   	   overf : out std_logic
	 	 	 );
	end component alu32;

	component shift_left_2 is
		generic(width : natural := 32);
		port( x :  in std_logic_vector(width-1 downto 0);
      	  	  y : out std_logic_vector(width-1 downto 0));
	end component shift_left_2;

	-- alu wires
	signal alu_src_b : std_logic_vector(31 downto 0);
	signal zero : std_logic;

	-- next pc wires
	signal signextend_imm_shift2 : std_logic_vector(31 downto 0);
	signal branch_addr : std_logic_vector(31 downto 0);
	signal next_pc_N : std_logic_vector(31 downto 0);

begin

	-- control signal pass through
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	MemRead_o  <= MemRead_i;
	MemWrite_o <= MemWrite_i;

	-- datapath pass through
	reg_write_addr_o <= reg_write_addr_i;
	mem_write_data_o <= RD2_i;

	-- mux the b input of the alu between the immediate or the second reg
	alu_src_b <= signextend_imm_i when ALUSrc_i = '1' else RD2_i;

	mips_alu : alu32
		port map(a => RD1_i,
				 b => alu_src_b,
			     oper => ALUOp_i,
			     result => alu_result_o,
			     zero => zero,
			     overf => open);

	-- calculate the next pc

	mips32_shift_left_2 : shift_left_2
		port map(x => signextend_imm_i, y => signextend_imm_shift2);

	branch_addr <= std_logic_vector(signed(signextend_imm_shift2) + signed(pc_plus4_i));

	-- cascading muxes to decide between pc+4, branch address or jump address
	-- for the next address that will be executed
	next_pc_N <= branch_addr when (zero and Branch_i) = '1' else pc_plus4_i;
	pc_next_o <= jump_addr_i when jump_i = '1' else next_pc_N;

end struc;
