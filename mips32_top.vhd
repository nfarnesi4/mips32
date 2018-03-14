library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mips32_top is
	port (clk : in std_logic;
		  overflow : out std_logic);
end entity mips32_top;

architecture struc of mips32_top is

	-- controllers

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

	-- memories

	component PC is
		port (clk : in std_logic;
      	  	  addr_in : in std_logic_vector(31 downto 0);
      	  	  addr_out : out std_logic_vector(31 downto 0));
	end component PC;

	component regfile is
		port (clk : in std_logic;
	      	  RR1, RR2, WR : in std_logic_vector(4 downto 0);
		  	  RegWrite : in std_logic;
	      	  WD       : in std_logic_vector(31 downto 0);
	      	  RD1, RD2 : out std_logic_vector(31 downto 0));
	end component regfile;

	component dmemory is
		port (clk : in std_logic;
	      	  mem_read, mem_write : in std_logic;
	      	  address : in std_logic_vector(31 downto 0);
	      	  write_data : in std_logic_vector(31 downto 0);
	      	  read_data : out std_logic_vector(31 downto 0));
	end component dmemory;

	component imemory is
		port ( address : in std_logic_vector(31 downto 0);
	       	   data : out std_logic_vector(31 downto 0));
	end component imemory;

	-- hardware

	component alu32 is
		generic (n : natural := 32);
		port (a, b : in std_logic_vector(n-1 downto 0);
	  	  	  oper : in std_logic_vector(3 downto 0);
	  	  	  result : out std_logic_vector(n-1 downto 0);
	    		zero : out std_logic;
	   	   	   overf : out std_logic
	 	 	 );
	end component alu32;

	component sign_extend is
		generic ( in_width : natural := 16;
         	 	 out_width : natural := 32);
		port (x :  in std_logic_vector(in_width-1 downto 0);
      	  	  y : out std_logic_vector(out_width-1 downto 0));
	end component sign_extend;

	component shift_left_2 is
		generic(width : natural := 32);
		port( x :  in std_logic_vector(width-1 downto 0);
      	  	  y : out std_logic_vector(width-1 downto 0));
	end component shift_left_2;

	component shift_left_2_jump is
		port ( imm :  in std_logic_vector(25 downto 0);
   	   	   pc_4msb :  in std_logic_vector(3 downto 0);
 	 	 jump_addr : out std_logic_vector(31 downto 0));
	end component shift_left_2_jump;

	component mux32 is
    	port(x,y: in std_logic_vector(31 downto 0);
         	 sel: in std_logic;
	 	     z  : out std_logic_vector(31 downto 0));
	end component mux32;

	component mux is
    	generic ( n: natural := 32 );
    	port ( x,y: in std_logic_vector(n-1 downto 0);
           	   sel: in std_logic;
           	   z: out std_logic_vector(n-1 downto 0) );
	end component mux;

	--control wires
	signal RegDst, Branch, MemRead, MemtoReg, ALUSrc,
	       RegWrite, MemWrite, jump : std_logic;
	signal ALUOp : std_logic_vector(1 downto 0);
	signal operation : std_logic_vector(3 downto 0);
	signal zero : std_logic;

	-- datapath wires
	signal a,c,d,e,f,g,h,j,k,l,m,n,p,q:std_logic_vector(31 downto 0);
	signal b : std_logic_vector(4 downto 0);
	signal r : std_logic;
	signal instruction : std_logic_vector(31 downto 0);

begin

	-- instruction fetech

	mips32_pc : pc
		port map (clk => clk, addr_in => p, addr_out => a);

	mips32_imem : imemory
		port map (address => a, data => instruction);

	-- pc + 4
	l <= std_logic_vector(to_signed(4, a'length) + signed(a));

	-- instruction decode

	mips32_controller : controller
		port map (opcode => instruction(31 downto 26),
		          RegDst => RegDst,
		          MemRead => MemRead,
		          MemWrite => MemWrite,
		          MemtoReg => MemtoReg,
		          ALUSrc => ALUSrc,
		          RegWrite => RegWrite,
		          Branch => Branch,
		          jump => jump,
		          ALUOp => ALUOp);


	mipd32_jum_calc : shift_left_2_jump
		port map (imm => instruction(25 downto 0),
		          pc_4msb => a(31 downto 28),
		          jump_addr => q);

	mips32_reg_dest_mux : mux
		generic map (n => b'length)
		port map (sel => RegDst,
				  x => instruction(20 downto 16),
				  y => instruction(15 downto 11),
				  z => b);

	mips32_regfile : regfile
		port map (clk => clk,
		          RegWrite => RegWrite,
		          RR1 => instruction(25 downto 21),
		          RR2 => instruction(20 downto 16),
		          WR => b,
		          WD => j,
		          RD1 => c,
		          RD2 => d);

	mip32_sign_ext : sign_extend
		port map (x => instruction(15 downto 0), y => e);

	-- execute

	mips32_alu_mux : mux32
		port map (x => d, y => e, sel => ALUSrc,  z => f);

	mips_alucntrl : alu_control
		port map (ALUOp => ALUOp,
		          Funct => instruction(5 downto 0),
		          Operation => operation);

	mips32_alu : alu32
		port map (a => c, b => f, oper => operation,
		          result => g, zero => zero, overf => overflow);

	mips32_imm_shift : shift_left_2
		port map (x => e, y => k);

	-- branch address calculation 4*(signed extended imm) + (pc + 4)
	m <= std_logic_vector(signed(l) + signed(k));

	-- branch mux select
	r <= zero and branch;

	mips32_branch_mux : mux32
		port map (x => l, y => m, sel => r, z => n);

	mips32_jump_mux : mux32
		port map (x => n, y => q, sel => jump, z => p);

	-- memory

	mips32_dmem : dmemory
		port map (clk => clk,
		          mem_read => MemRead, mem_write => MemWrite,
		          address => g,
		          write_data => d,
		          read_data => h);

	-- write back

	mips32_reg_write_data_mux : mux32
		port map (x => g, y => h, sel => MemtoReg, z => j);

end struc;
