----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2018 08:32:06 PM
-- Design Name: 
-- Module Name: Mux5 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
port (clk : in std_logic;
      addr_in : in std_logic_vector(31 downto 0);
      addr_out : out std_logic_vector(31 downto 0));
end PC;

architecture RTL of PC is

component reg is

generic (width : natural := 32);
port (clk :  in std_logic;
   reg_in :  in std_logic_vector(width-1 downto 0);
  reg_out : out std_logic_vector(width-1 downto 0));
end component;

begin

reg32 : reg generic map (width => 32) port map (clk => clk, reg_in => addr_in, reg_out => addr_out);

end RTL;
