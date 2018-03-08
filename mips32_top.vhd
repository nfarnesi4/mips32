library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mips32_top is
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

	component mux32 is
    	port(x,y: in std_logic_vector(31 downto 0);
         	 sel: in std_logic;
	 	 z  : out std_logic_vector(31 downto 0));
	end component mux32;

	-- wires

	--control wires
--	signal Jump, branch, MemRead, MemtoReg, MemRead

	-- datapath wires
	signal a, b, c, d, f, g, h, i, j, k, l, m, n, o, p, q : std_logic_vector(31 downto 0);

begin


end struc;
