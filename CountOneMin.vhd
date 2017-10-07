LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity CountOneMin is
   port(
 	 clock: in std_logic;
 	 output: out std_logic_vector(3 downto 0));
end CountOneMin;

architecture CountOneMin_behaviour of CountOneMin is
   signal temp,division: std_logic_vector(0 to 25) := (others => '0');
	signal temp2,division2: std_logic_vector(5 downto 0) := (others => '0');
begin   process(clock)
   begin
      if(rising_edge(clock)) then
				division <= "10111110101111000010000001";
				division2 <= "111100";
            if temp=division then
               temp<="00000000000000000000000000";
					temp2 <= temp2 + 1;
					if temp2=division2 then
						temp2 <= (others => '0');
						output <= "0001";
					else
						output <= "0000";
					end if;
            else
               temp <= temp + 1;
					output <= "0000";
            end if;
         end if;
   end process;
end CountOneMin_behaviour;