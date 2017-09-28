library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tempo_alarme is
	port (
			  CLOCK_50 : in STD_LOGIC;
			  B : in STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); --SM1 control 1 MUX
			  CV : in STD_LOGIC_VECTOR(3 downto 0);
			  V : out STD_LOGIC_VECTOR(6 downto 0);
			  S : out STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
			  Sreg : out STD_LOGIC_VECTOR(3 downto 0);
			  EN : in STD_LOGIC := '1';
			  alarme_mode : in STD_LOGIC;
			  btn1 : in STD_LOGIC
		 );
end entity;


architecture tempo_architecture of tempo_alarme is
	signal ULA_IN_A,REG_R, REG_A,a_output,r_output, ULA_OUT, OUTPUT, mux_output, xor_output : std_logic_vector(3 downto 0) := (others=>'0');
	signal overflowLocal, enable, mux_out_select_reg: std_logic;
	begin
		 reg : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => r_output, DOUT => REG_R, CLK => CLOCK_50, RST => '0', ENABLE => EN);
				
		 reg_alarme : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => a_output, DOUT => REG_A, CLK => CLOCK_50, RST => '0', ENABLE => EN);
				
		 MUX_MUX : entity work.mux0
				port map (A => '0', B=> btn1, SEL=> alarme_mode, X => mux_out_select_reg);
				
		 MUX_REG : entity work.mux1
				port map (A => REG_R, b=> REG_A, SEL =>  mux_out_select_reg, X => ULA_IN_A);
				
		 DEMUX_REG : entity work.demux2
				port map (X => mux_output, SEL => mux_out_select_reg, A => r_output, B => a_output);
				
		 MUX_DISPLAY_ALARM : entity work.mux1
				port map (A => REG_R, B => REG_A, SEL => alarme_mode, X => OUTPUT);
				
		 ULA : entity work.ULA
				generic map ( larguraDados => 4 )
				port map (A => ULA_IN_A, B => B, C => ULA_OUT, Sel => "00", overflow => overflowLocal);
		 XOR1 : entity work.xor2
				port map (A1 => ULA_OUT, A2 => CV, X1 => xor_output);
		 MUX1 : entity work.mux2
				port map (A => ULA_OUT, B => (others => '0'), SEL => xor_output, X => mux_output);
		 display0 : entity work.conversorHex7seg
				port map (saida7seg => V, dadoHex => OUTPUT, apaga => overflowLocal);
		 saida : entity work.not2
				port map (A => xor_output, X => S);
		 Sreg <= ULA_IN_A;
	end tempo_architecture;