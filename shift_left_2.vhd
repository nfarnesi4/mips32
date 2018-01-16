----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2018 09:39:42 PM
-- Design Name: 
-- Module Name: shift_left_2 - rtl
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

entity shift_left_2 is

generic(width : natural := 32);
port( x :  in std_logic_vector(width-1 downto 0);
      y : out std_logic_vector(width-1 downto 0));
end shift_left_2;

architecture rtl of shift_left_2 is

begin

y <= x(width-3 downto 0) & "00";

end rtl;
