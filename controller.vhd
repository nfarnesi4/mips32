library ieee;
use ieee.std_logic_1164.all;

entity controller is
	port (opcode : in std_logic_vector(5 downto 0);
	      RegDst, Branch, MemRead, MemtoReg : out std_logic;
	      ALUSrc, RegWrite, MemWrite, jump  : out std_logic;
	      ALUOp : out std_logic_vector(1 downto 0)
	);
end entity controller;

architecture rtl of controller is

begin

	process(opcode)
	begin
		case opcode is

		-- r-format
		when "000000" =>
			RegDst   <= '1';
			ALUSrc   <= '0';
			ALUOp    <= "10";
			MemRead  <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= '1';
			Branch   <= '0';
			jump     <= '0';

		-- lw
		when "100011" =>
			RegDst   <= '0';
			ALUSrc   <= '1';
			ALUOp    <= "00";
			MemRead  <= '1';
			MemWrite <= '0';
			MemtoReg <= '1';
			RegWrite <= '1';
			Branch   <= '0';
			jump     <= '0';

		-- sw
		when "101011" =>
			RegDst   <= '0';
			ALUSrc   <= '1';
			ALUOp    <= "00";
			MemRead  <= '0';
			MemWrite <= '1';
			MemtoReg <= '0';
			RegWrite <= '0';
			Branch   <= '0';
			jump     <= '0';

		-- beq
		when "000100" =>
			RegDst   <= '0';
			ALUSrc   <= '0';
			ALUOp    <= "01";
			MemRead  <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			Branch   <= '1';
			jump     <= '0';

		-- j
		when "000010" =>
			RegDst   <= '0';
			ALUSrc   <= '0';
			ALUOp    <= "00";
			MemRead  <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			Branch   <= '0';
			jump     <= '1';

		-- don't care about others
		when others => NULL;
		end case;
	end process;
end rtl;
