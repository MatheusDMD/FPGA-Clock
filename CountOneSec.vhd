LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity CountOneSec is
   port(
	 speed: in std_logic := '0';
 	 clock: in std_logic;
 	 output: out std_logic_vector(3 downto 0));
end CountOneSec;

architecture CountOneSec_behaviour of CountOneSec is
   signal temp, division: std_logic_vector(0 to 25) := (others => '0');
begin   process(clock)
   begin
      if(rising_edge(clock)) then
				if(speed = '0') then
					division <= "10111110101111000010000000";
				else
					division <= "00000000001100001101010000";
				end if;
            if temp=division then
               temp<="00000000000000000000000000";
					output <= "0001";
            else
               temp <= temp + 1;
					output <= "0000";
            end if;
         end if;
   end process;
end CountOneSec_behaviour;