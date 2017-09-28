library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux2 is
    Port ( SEL : in  STD_LOGIC;
           A   : out  STD_LOGIC_VECTOR (3 downto 0);
           B   : out  STD_LOGIC_VECTOR (3 downto 0);
           X   : in STD_LOGIC_VECTOR (3 downto 0));
end demux2;

architecture Behavioral of demux2 is
begin
    process(X)
		begin
			if(SEL = '0') then
				A <= X;
			else
				B <= X;
			end if;
		end process;
end Behavioral;