library ieee;
use ieee.std_logic_1164.all;

entity decode is
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

end entity decode;

architecture struc of decode is

	component shift_left_2_jump is
		port ( imm :  in std_logic_vector(25 downto 0);
   	   	   pc_4msb :  in std_logic_vector(3 downto 0);
 	 	 jump_addr : out std_logic_vector(31 downto 0));
	end component shift_left_2_jump;

    component sign_extend
    	generic (in_width : natural := 16;
    		 out_width : natural := 32);
    	port (x :  in std_logic_vector(in_width-1 downto 0);
    	      y : out std_logic_vector(out_width-1 downto 0));
    end component;

	component regfile is
		port (clk : in std_logic;
	      	  RR1, RR2, WR : in std_logic_vector(4 downto 0);
		  	  RegWrite : in std_logic;
	      	  WD       : in std_logic_vector(31 downto 0);
	      	  RD1, RD2 : out std_logic_vector(31 downto 0));
	end component regfile;

	component controller is
		port (opcode : in std_logic_vector(5 downto 0);
	      	  RegDst, Branch, MemRead, MemtoReg : out std_logic;
	      	  ALUSrc, RegWrite, MemWrite, jump  : out std_logic;
	      	  ALUOp : out std_logic_vector(1 downto 0)
		);
	end component controller;

	component alu_control is
		port (ALUOp : in std_logic_vector(1 downto 0);
	      	  Funct : in std_logic_vector(5 downto 0);
	      	  Operation : out std_logic_vector(3 downto 0)
		);
	end component alu_control;

	-- wires
	signal ALUop_contr : std_logic_vector(1 downto 0);
	signal RegDst : std_logic;

begin

	mips32_regfile : regfile
		port map (clk => clk,
		          RR1 => instr_i(25 downto 21), RR2 => instr_i(20 downto 16),
		          WR  => reg_write_addr_i, RegWrite => RegWrite_i,
		          WD  => reg_write_data_i,
		          RD1 => RD1_o, RD2 => RD2_o);

	mips32_controller : controller
		port map (opcode => instr_i(31 downto 26),
				 RegDst => RegDst, Branch => Branch_o, MemRead => MemRead_o, MemtoReg => MemtoReg_o,
			     ALUSrc => ALUSrc_o, RegWrite => RegWrite_o, MemWrite => MemRead_o, jump => jump_o,
			     ALUOp  => ALUop_contr);

	mips32_alu_con : alu_control
		port map (ALUOp => ALUOp_contr,
		         Funct => instr_i(5 downto 0),
		         Operation => ALUOp_o);

	mips32_shift_left_2_jump : shift_left_2_jump
		port map (imm => instr_i(25 downto 0),
		          pc_4msb => pc_plus4_i(31 downto 28),
		          jump_addr => jump_addr_o);

	mips32_signextend : sign_extend
		port map (x => instr_i(15 downto 0),
		          y => signextend_imm_o);

		reg_write_addr_o <= instr_i(15 downto 11) when RegDst = '1'
							else instr_i(20 downto 16);

end struc;
