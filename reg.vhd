----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2018 09:06:51 PM
-- Design Name: 
-- Module Name: reg - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
generic (width : natural := 32);
port (clk :  in std_logic;
   reg_in :  in std_logic_vector(width-1 downto 0);
  reg_out : out std_logic_vector(width-1 downto 0));
end reg;

architecture behv of reg is
    signal value_reg : std_logic_vector(width-1 downto 0) := (others => '0');
begin

process(clk)
begin
    if rising_edge(clk) then
        value_reg <= reg_in;
    end if;
end process;

reg_out <= value_reg;

end behv;
