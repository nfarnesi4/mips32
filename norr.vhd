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
    port (x : in std_logic_vector(n-1 downto 0);
          z: out std_logic);
end entity;

-- Declare architecture
architecture dataflow of norr is
    signal s : std_logic_vector(n downto 0);
begin
    gen_norr : for i in 0 to n-1 generate
    	s(i+1) <= x(i) nor s(i);
    end generate;
    z <= s(n);
end architecture;
