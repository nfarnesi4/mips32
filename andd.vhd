--------------------------------------------------------------------------------
-- Component: andd
-- Description: and gate
-- Author: Anshul Kharbanda
-- Created: 1 - 16 - 2017
--------------------------------------------------------------------------------
-- Libraries
library ieee;
use ieee.std_logic_1164.all;

-- Declare entity
entity andd is
    generic ( n: natural := 1 );
    port ( x,y: in std_logic_vector(n-1 downto 0);
           z: out std_logic_vector(n-1 downto 0) );
end entity;

-- Declare architecture
architecture dataflow of andd is
begin

    z <= x and y;

end architecture;
