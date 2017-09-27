library ieee;
use ieee.std_logic_1164.all;

--ENTITY DECLARATION: name, inputs, outputs
entity not2 is
   port( A  : in STD_LOGIC_VECTOR(3 downto 0);
         X : out STD_LOGIC_VECTOR(3 downto 0));
end not2;

--FUNCTIONAL DESCRIPTION: how the Inverter works
architecture func of not2 is
begin
   X(0) <= (not A(0));
end func;