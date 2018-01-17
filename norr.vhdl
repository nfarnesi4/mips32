--------------------------------------------------------------------------------
-- Component: norr
-- Description: not gate
-- Author: Anshul Kharbanda
-- Created: 1 - 16 - 2017
--------------------------------------------------------------------------------
-- Libraries
library ieee;
use ieee.std_logic_1164.all;

-- Declare entity
entity norr is
    generic ( n: natural := 32 );
    port ( x,y: in std_logic_vector(n-1 downto 0);
           z: out std_logic_vector(n-1 downto 0) );
end entity;

-- Declare architecture
architecture dataflow of norr is
begin
    gen_not: for i in n-1 downto 0 generate
        z(i) <= x(i) nor y(i);
    end generate;
end architecture;
