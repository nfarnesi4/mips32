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
    port (x : in std_logic_vector;
          z: out std_logic);
end entity;

-- Declare architecture
architecture dataflow of norr is
begin

    z <= '1' when x = (x'range => '0') else '0';

end architecture;
