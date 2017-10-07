library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMtopLevel is
	port (
			  -- Entradas (nomenclatura definida no arquivo ¨.qsf¨)
			  CLOCK_50 : in STD_LOGIC;
			  KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);    --chaves de contato momentaneo.
			  SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);    --chaves liga/desliga.

			  -- Saidas da placa (nomenclatura definida no arquivo ¨.qsf¨)
			  LEDR : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
			  LEDG : out STD_LOGIC_VECTOR(8 DOWNTO 0)  := (others => '0');
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR(6 downto 0)
		 );
end entity;


architecture FSMtopLevel_architecture of FSMtopLevel is
	signal output_us,output_ds,output_um,output_dm,output_uh,output_dh,reg_dh,cv_uh, OUTPUT: std_logic_vector(3 downto 0) := (others=>'0');
	signal mux_set_out1, mux_set_out2,mux_set_out3, btn_set_output,pulse_minus: std_logic_vector(3 downto 0) := (others=>'0');
	signal control : std_logic_vector(2 downto 0);
	signal control_alarm, control_countdown: std_logic_vector(3 downto 0);
	signal mux_selector,mux_selector2,count_compare: std_logic;
	signal alarm_um,alarm_dm,alarm_uh,alarm_dh,alarm_check: std_logic := '0';
	begin
		
		--MAQUINA DE ESTADOS - RELOGIO
		SM_relogio : entity work.SM1
				port map (clock => CLOCK_50, set => SW(1), h_m => SW(2), saida => control);
				
		--MAQUINA DE ESTADOS - ALARME
		
		SM_alarm : entity work.alarmSM
		   	port map (clock => CLOCK_50, alarm_mode => SW(16), h_m => SW(17), saida=> control_alarm);
				
		-- MAQUINA DE ESTADOS - COUNTDOWN
		SM_countdown : entity work.countdownSM
		   	port map (clock => CLOCK_50, count_mode => SW(8), h_m => SW(9), saida=> control_countdown);
				
		--SET MINUTO
		mux_set_minuto : entity work.mux1
				port map (A => output_ds, B => btn_set_output, SEL => mux_selector, X => mux_set_out1);
		--SET HORA
		mux_set_hora : entity work.mux1
				port map (A => output_dm, B => btn_set_output, SEL => mux_selector2, X => mux_set_out2);
		--SET
		btn_set : entity work.debounce
				port map (CLK => CLOCK_50, BTN => (not KEY(0)), output => btn_set_output);
				
		--COUNT SECONDS
		counter : entity work.CountOneSec
				port map (speed => SW(0), clock => CLOCK_50, output => OUTPUT);
		--COUNT DOWN MINUTES
		counter_min : entity work.CountOneMin
				port map ( clock => CLOCK_50, output => pulse_minus);		
				
		--MUX ALARME MODE
		mux_alarme_mode : entity work.mux0
				port map (A => control(1), B => btn_set_output(0), SEL => control_alarm(0), X => mux_selector);
		mux_alarme_mode2 : entity work.mux0
				port map (A => control(2), B => btn_set_output(0), SEL => control_alarm(0), X => mux_selector2);
		
		-- SEGUNDOS
		unidade_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => OUTPUT, CV => "1010", V => HEX2, S => output_us, EN => control(0),
				dezena => '0',count => (SW(7) or SW(8)), alarm => SW(16));
		dezena_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_us, CV => "0110", V => HEX3, S => output_ds,
				dezena => '1',count => (SW(7) or SW(8)), alarm => SW(16));		
				
		--MINUTOS
		unidade_minuto : entity work.tempo_alarme
				port map (CLOCK_50 => CLOCK_50, B => mux_set_out1, CV => "1010", V => HEX4, S => output_um,
				--alarm_inputs
				alarme_mode=> control_alarm(0), btn1 => btn_set_output(0), EN_A => control_alarm(2),
				alarm_compare=> alarm_um, RST_A => control_alarm(3),
				--countdown_inputs
				count_compare => count_compare,pulse_minus => pulse_minus(0), en_counting => (control_countdown(0) or SW(8)),
				RST_C => control_countdown(3),EN_C => control_countdown(2));
		dezena_minuto : entity work.tempo_alarme
				port map (CLOCK_50 => CLOCK_50, B => output_um, CV => "0110", V => HEX5, S => output_dm,
				--alarm_inputs
				alarme_mode=> control_alarm(0), btn1 => btn_set_output(0), alarm_compare => alarm_dm, 
				RST_A => control_alarm(3),
				--countdown_inputs
				count_compare => count_compare,pulse_minus => pulse_minus(0), en_counting => (control_countdown(0) or SW(8)),
				RST_C => control_countdown(3),EN_C => control_countdown(1));
			
				
		--HORAS
		unidade_hora : entity work.tempo_alarme
				port map (CLOCK_50 => CLOCK_50, B => mux_set_out3, CV => cv_uh, V => HEX6, S => output_uh,
				--alarm_inputs
				alarme_mode=> control_alarm(0), btn1 => btn_set_output(0), EN_A => control_alarm(1), 
				alarm_compare => alarm_uh, RST_A => control_alarm(3),
				--countdown_inputs
				count_compare => count_compare,pulse_minus => pulse_minus(0), en_counting => (control_countdown(0) or SW(8)),
				RST_C => control_countdown(3),EN_C => control_countdown(2));
				
		dezena_hora : entity work.tempo_alarme
				port map (CLOCK_50 => CLOCK_50, B => output_uh, CV => "0011", V => HEX7, S => output_dh, Sreg => reg_dh,
				--alarm_inputs
				alarme_mode=>control_alarm(0), btn1 => btn_set_output(0), alarm_compare => alarm_dh,
				RST_A => control_alarm(3),
				--countdown_inputs
				count_compare => count_compare,pulse_minus => pulse_minus(0), en_counting => (control_countdown(0) or SW(8)),
				RST_C => control_countdown(3),EN_C => control_countdown(1));
		
		--ALARM COMPARE
		compare_alarm : entity work.alarm_and
				port map (A =>(not alarm_um), B=> (not alarm_dm), C=>(not alarm_uh), D=>(not alarm_dh), X=>alarm_check);
				
		
		--LEDs
		process(control)
			begin
				if(control = "100") then
					LEDR(17) <= '1';
					LEDR(14) <= '0';
					LEDG(0) <= btn_set_output(0);
				elsif(control = "010") then
					LEDR(14) <= '1';
					LEDR(17) <= '0';
					LEDG(0) <= btn_set_output(0);
				else
					LEDR(14) <= '1';
					LEDR(17) <= '1';
					LEDG(0) <= '1';
				end if;
			end process;
		
		process(reg_dh)
			begin
				if(reg_dh = "0010") then
					cv_uh <= "0100";
				else
					cv_uh <= "1010";
				end if;
		end process;
		
		process(alarm_check)
			begin
				if((alarm_check = '1') and (SW(15) = '1')) then
					LEDG(7 downto 1) <= (others => '1');
				else
					LEDG(7 downto 1) <= (others => '0');
				end if;
			end process;
		
		LEDR(0) <= SW(0);
		HEX0 <= "1111111";
		HEX1 <= "1111111";
	end FSMtopLevel_architecture;
