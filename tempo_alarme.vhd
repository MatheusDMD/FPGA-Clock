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
			  EN_A : in STD_LOGIC := '1';
			  RST_A : in STD_LOGIC := '1';
			  alarme_mode : in STD_LOGIC;
			  d_u : in STD_LOGIC;
			  h_m : in STD_LOGIC;
			  btn1 : in STD_LOGIC;
			  alarm_compare : out STD_LOGIC
		 );
end entity;


architecture tempo_architecture of tempo_alarme is
	signal ULA_IN_A,MUX_REG_COUNT_IN,REG_R,REG_C,REG_A,a_output,r_output,c_output, ULA_OUT, OUTPUT,display_mux_output, mux_output,mux_count_output, xor_output : std_logic_vector(3 downto 0) := (others=>'0');
	signal overflowLocal, enable, mux_out_select_reg,mux_out_select_reg_count,RST_A_OR, RST_A_FORCE: std_logic;
	signal operation : std_logic_vector(1 downto 0) := (others => '0'); 
	begin
		 reg : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => r_output, DOUT => REG_R, CLK => CLOCK_50, RST => '0', ENABLE => EN);
		 reg_alarme : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => a_output, DOUT => REG_A, CLK => CLOCK_50, RST => RST_A_OR, ENABLE => EN_A);

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
				port map (A => ULA_IN_A, B => B, C => ULA_OUT, Sel => "00");
		 XOR1 : entity work.xor2
				port map (A1 => ULA_OUT, A2 => CV, X1 => xor_output);
		 MUX1 : entity work.mux2
				port map (A => ULA_OUT, B => (others => '0'), SEL => xor_output, X => mux_output);
		 display0 : entity work.conversorHex7seg
				port map (saida7seg => V, dadoHex => OUTPUT);
		 saida : entity work.not2
				port map (A => xor_output, X => S);
		 Sreg <= ULA_IN_A;
		 
		 compare_alarm : entity work.xor1
				port map (A1 => REG_A, A2 => REG_R , X1 => alarm_compare);
		
		RST_A_OR <= (RST_A or RST_A_FORCE);
		
		 process(REG_A,d_u,h_m)
			begin
				if(d_u = '1')then
					if(h_m = '1')then
						if(REG_A > "0011")then
							RST_A_FORCE <= '1';
						else
							RST_A_FORCE <= '0';
						end if;
					else
						if(REG_A > "0101")then
							RST_A_FORCE <= '1';
						else
							RST_A_FORCE <= '0';
						end if;
					end if;
				else
					if(h_m = '1')then
						if(REG_A >= "1010")then
							RST_A_FORCE <= '1';
						else
							RST_A_FORCE <= '0';
						end if;
					else
						if(REG_A > "1001")then
							RST_A_FORCE <= '1';
						else
							RST_A_FORCE <= '0';
						end if;
					end if;
				end if;
			end process;
			
	end tempo_architecture;