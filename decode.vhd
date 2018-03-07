library ieee;
use ieee.std_logic_1164.all;

entity decode is
	port (clk : in std_logic;

	--control signals in
	RegWrite_i : in std_logic;

	--control signals out
	RegDst_o, Branch_o, MemRead_o, MemtoReg_o : out std_logic;
	ALUSrc_o, RegWrite_o, MemWrite_o, jump_o  : out std_logic;
	ALUOp_o : out std_logic_vector(3 downto 0);

	--datapath in
	instr : in std_logic_vector(31 downto 0);
	reg_write_addr : in std_logic_vector(4 downto 0);
	reg_write_data : in std_logic_vector(31 downto 0);
	pc_plus4_i : in std_logic_vector(31 downto 0);

	--datapath out
	RD1, RD2 : out std_logic_vector(31 downto 0);
	RtE, RdE : out std_logic_vector(4 downto 0); --write reg addr
	signextend_imm : out std_logic_vector(31 downto 0);
	jump_addr : out std_logic_vector(31 downto 0);
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

begin

	mips32_regfile : regfile
		port map (clk => clk,
		          RR1 => instr(25 downto 21), RR2 => instr(20 downto 16),
		          WR  => reg_write_addr, RegWrite => RegWrite_i,
		          WD  => reg_write_data,
		          RD1 => RD1, RD2 => RD2);

	mips32_controller : controller
		port map (opcode => instr(31 downto 26),
				 RegDst => RegDst_o, Branch => Branch_o, MemRead => MemRead_o, MemtoReg => MemtoReg_o,
			     ALUSrc => ALUSrc_o, RegWrite => RegWrite_o, MemWrite => MemRead_o, jump => jump_o,
			     ALUOp  => ALUop_contr);

	mips32_alu_con : alu_control
		port map (ALUOp => ALUOp_contr,
		         Funct => instr(5 downto 0),
		         Operation => ALUOp_o);

	mips32_shift_left_2_jump : shift_left_2_jump
		port map (imm => instr(25 downto 0),
		          pc_4msb => pc_plus4_i(31 downto 28),
		          jump_addr => jump_addr);

	mips32_signextend : sign_extend
		port map (x => instr(15 downto 0),
		          y => signextend_imm);

	RtE <= instr(20 downto 16);
	RdE <= instr(15 downto 11);

end struc;
