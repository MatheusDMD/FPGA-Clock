library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    Port ( A :  in std_logic_vector(7 downto 0);
           B :  in std_logic_vector(7 downto 0);
        Sel: in std_logic_vector(1 downto 0);
           C : out std_logic_vector(7 downto 0);
        overflow: out std_logic
   );
end entity;

architecture comportamento of ULA is

begin
  process (A, B, Sel) is
    variable tempOF : std_logic_vector(2 downto 0);
    variable C9     : std_logic_vector(8 downto 0);
  begin
    C9 := (others => '0');
    case Sel is
      when "00" => C9 := std_logic_vector(resize(signed(std_logic_vector(signed(A) + signed(B))), C9'length));
      when "01" => C9 := std_logic_vector(resize(signed(std_logic_vector(signed(A) - signed(B))), C9'length));
      when "10" => C9(8 downto 0) := '0' & std_logic_vector(A XOR B);
      when "11" => C9(8 downto 0) := '0' & std_logic_vector(A AND B);
      when others => C9 := (others => '0');
    end case;
    C(7 downto 0) <= C9(7 downto 0);
    case Sel is
      -- overflow = "b001" (entrada POSITIVA e saida NEGATIVA)  OU "b110" (entrada NEGATIVA e saida POSITIVA)
      when "00" => tempOF := A(A'high) & B(B'high) & C9(C9'high-1);       
      when "01" => tempOF := A(A'high) & not(B(B'high)) & C9(C9'high-1);
      when others => tempOF := (others => '0');
    end case;
    case tempOF is
      when "001"  => overflow <= '1';
      when "110"  => overflow <= '1';
      when others => overflow <= '0';
    end case;
  end process;
end architecture;