library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux0 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           X   : out STD_LOGIC);
end mux0;

architecture Behavioral of mux0 is
begin
    X <= A when (SEL = '0') else B;
end Behavioral;