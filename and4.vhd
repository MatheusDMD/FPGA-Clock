library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and4 is
    Port ( A1 : in  STD_LOGIC;
           A2 : in  STD_LOGIC;
			  A3 : in  STD_LOGIC;     
			  A4 : in  STD_LOGIC;     
           X1 : out  STD_LOGIC    
			  );
end and4;

architecture Behavioral of and4 is
begin
	process(A1,A2,A3,A4)
		begin
			if(A1 = '1' and A2 = '1' and A3 = '1' and A4 = '1') then
				X1 <= '1';		-- 2 input exclusive-OR
			else
				X1 <= '0';
			end if;
	end process;
end Behavioral;