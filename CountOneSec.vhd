LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity CountOneSec is
   port(
 	 clock: in std_logic;
 	 reset: in std_logic;
 	 output: out std_logic_vector(3 downto 0));
end CountOneSec;

architecture CountOneSec_behaviour of CountOneSec is
   signal temp: std_logic_vector(0 to 25) := (others => '0');
begin   process(clock,reset)
   begin
      if reset='1' then
      elsif(rising_edge(clock)) then
            if temp="10111110101111000010000000" then
               temp<="00000000000000000000000000";
					output <= "0001";
            else
               temp <= temp + 1;
					output <= "0000";
            end if;
         end if;
   end process;
end CountOneSec_behaviour;