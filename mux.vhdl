--------------------------------------------------------------------------------
-- Component: mux
-- Description: Generic multiplexer
-- Author: Anshul Kharbanda
-- Created: 1 - 16 - 2017
--------------------------------------------------------------------------------
-- Libraries
library ieee;
use ieee.std_logic_1164.all;

-- Declare entity
entity mux is
    generic ( n: natural := 32 );
    port ( x,y: in std_logic_vector(n-1 downto 0);
           sel: in std_logic;
           z: out std_logic_vector(n-1 downto 0) );
end entity;

-- Declare architecture
architecture behavior of mux is
begin
    z <= y when sel='1' else x;
end architecture;
