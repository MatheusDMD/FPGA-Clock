library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alarm_and is
    Port ( A : in  STD_LOGIC := '0';
           B : in  STD_LOGIC := '0';
			  C : in  STD_LOGIC := '0';     
			  D : in  STD_LOGIC := '0';     
           X : out  STD_LOGIC := '0'    
			  );
end alarm_and;

architecture Behavioral of alarm_and is
begin
	process(A,B,C,D)
		begin
			if((A = '1') and (B = '1') and (C = '1') and (D = '1')) then
				X <= '1';
			else
				X <= '0';
			end if;
	end process;
end Behavioral;