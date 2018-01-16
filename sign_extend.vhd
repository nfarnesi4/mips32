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

---- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

--entity sign_extend is
--generic ( in_width : natural := 15;
--         out_width : natural := 32);
--port (x :  in signed(in_width-1 downto 0);
--      y : out signed(out_width-1 downto 0));
--end sign_extend;

--architecture rtl of sign_extend is
--begin
--y <= resize(x, y'length);
--end rtl;

entity sign_extend is
generic ( in_width : natural := 15;
         out_width : natural := 32);
port (x :  in std_logic_vector(in_width-1 downto 0);
      y : out std_logic_vector(out_width-1 downto 0));
end sign_extend;

architecture rtl of sign_extend is
begin
y <= std_logic_vector(resize(signed(x), y'length));
end rtl;
