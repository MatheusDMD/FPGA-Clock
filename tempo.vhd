library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tempo is
	port (
			  CLOCK_50 : in STD_LOGIC;
			  B : in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
			  CV : in STD_LOGIC_VECTOR(3 downto 0);
			  V : out STD_LOGIC_VECTOR(6 downto 0);
			  S : out STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
			  Sreg : out STD_LOGIC_VECTOR(3 downto 0);
			  EN : in STD_LOGIC := '1';
			  alarm : in STD_LOGIC := '0';
			  dezena : in STD_LOGIC := '1'
			  );
end entity;


architecture tempo_architecture of tempo is
	signal ULA_IN_A, ULA_OUT, OUTPUT, mux_output, xor_output,display: std_logic_vector(3 downto 0) := (others=>'0');
	signal overflowLocal, enable: std_logic;
	begin
		 reg : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => mux_output, DOUT => ULA_IN_A, CLK => CLOCK_50, RST => '0', ENABLE => EN);
		 ULA : entity work.ULA
				generic map ( larguraDados => 4 )
				port map (A => ULA_IN_A, B => B, C => ULA_OUT, Sel => "00", overflow => overflowLocal);
		 XOR1 : entity work.xor2
				port map (A1 => ULA_OUT, A2 => CV, X1 => xor_output);
		 MUX1 : entity work.mux2
				port map (A => ULA_OUT, B => (others => '0'), SEL => xor_output, X => mux_output);
		 display0 : entity work.conversorHex7seg
				port map (saida7seg => V, dadoHex => display, apaga => overflowLocal);
		 saida : entity work.not2
				port map (A => xor_output, X => S);
		 Sreg <= ULA_IN_A;
		 
		 process(alarm)
			begin
				if(dezena = '1') then
					if(alarm = '1') then
						display <= "1010";
					else
						display <= ULA_IN_A;
					end if;
				else
					if(alarm = '1') then
						display <= "0001";
					else
						display <= ULA_IN_A;
					end if;
				end if;
			end process;
	end tempo_architecture;
