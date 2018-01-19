library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux32 is
    port(x,y: in std_logic_vector(31 downto 0);
         sel: in std_logic;
	 z  : out std_logic_vector(31 downto 0));
end mux32;

architecture behv of mux32 is
    component mux
        generic(n : natural := 32);
        port( x,y: in std_logic_vector(n-1 downto 0);
              sel: in std_logic;
              z  : out std_logic_vector(n-1 downto 0));
    end component;
begin

    mux_32 : mux generic map (32)
        port map (x => x,
        	  y => y,
        	  sel => sel,
        	  z => z);

end behv;
