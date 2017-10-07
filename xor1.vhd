library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor1 is
    Port ( A1 : in  STD_LOGIC_VECTOR(3 downto 0);      -- XOR gate input 1
           A2 : in  STD_LOGIC_VECTOR(3 downto 0);      -- XOR gate input 2
           X1 : out  STD_LOGIC    -- XOR gate output
			  );
end xor1;

architecture Behavioral of xor1 is
begin
	process(A1,A2)
		begin
			if((A1 xor A2) = "0000") then
				X1 <= '0';		-- 2 input exclusive-OR
			else
				X1 <= '1';
			end if;
	end process;
end Behavioral;