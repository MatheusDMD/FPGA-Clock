library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    Port ( SEL : in  STD_LOGIC_VECTOR (3 downto 0);
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end mux2;

architecture Behavioral of mux2 is
begin
    X <= B when (SEL = "0000") else A;
end Behavioral;