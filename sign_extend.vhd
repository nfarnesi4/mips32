library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity sign_extend is
generic ( in_width : natural := 16;
         out_width : natural := 32);
port (x :  in std_logic_vector(in_width-1 downto 0);
      y : out std_logic_vector(out_width-1 downto 0));
end sign_extend;

architecture rtl of sign_extend is
begin
y <= std_logic_vector(resize(signed(x), y'length));
end rtl;
