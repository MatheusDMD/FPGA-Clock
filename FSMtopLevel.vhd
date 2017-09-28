library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMtopLevel is
	port (
			  -- Entradas (nomenclatura definida no arquivo ¨.qsf¨)
			  CLOCK_50 : in STD_LOGIC;
			  KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);   --chaves de contato momentaneo.
			  SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);    --chaves liga/desliga.

			  -- Saidas da placa (nomenclatura definida no arquivo ¨.qsf¨)
			  LEDR : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
			  LEDG : out STD_LOGIC_VECTOR(8 DOWNTO 0)  := (others => '0');
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: OUT STD_LOGIC_VECTOR(6 downto 0)
		 );
end entity;


architecture FSMtopLevel_architecture of FSMtopLevel is
	signal output_us,output_ds,output_um,output_dm,output_uh,output_dh,reg_dh,cv_uh, OUTPUT: std_logic_vector(3 downto 0) := (others=>'0');
	signal mux_set_out1, mux_set_out2,mux_set_out3,btn_set_output: std_logic_vector(3 downto 0) := (others=>'0');
	signal control : std_logic_vector(2 downto 0);
	begin
		
		SM_relogio : entity work.SM1
				port map (clock => CLOCK_50, set => SW(1), h_m => SW(2), saida => control);
		
		--SET MINUTO
		mux_set_minuto : entity work.mux1
				port map (A => output_ds, B => btn_set_output, SEL => control(1), X => mux_set_out1);
		--SET HORA
		mux_set_hora : entity work.mux1
				port map (A => output_dm, B => btn_set_output, SEL => control(2), X => mux_set_out2);
		mux_set_hora2 : entity work.mux1
				port map (A => mux_set_out2, B => (others => '0') , SEL => control(1), X => mux_set_out3);
		--SET
		btn_set : entity work.debounce
				port map (CLK => CLOCK_50, BTN => (not KEY(0)), output => btn_set_output);
		--COUNT SECONDS
		counter : entity work.CountOneSec
				port map (speed => SW(0),clock => CLOCK_50, reset => '0', output => OUTPUT);

				
		-- SEGUNDOS
		unidade_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => OUTPUT, CV => "1010", V => HEX0, S => output_us, EN => control(0));
		dezena_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_us, CV => "0110", V => HEX1, S => output_ds);		
				
		--MINUTOS
		unidade_minuto : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => mux_set_out1, CV => "1010", V => HEX2, S => output_um);
		dezena_minuto : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_um, CV => "0110", V => HEX3, S => output_dm);
			
				
		--HORAS
		unidade_hora : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => mux_set_out3, CV => cv_uh, V => HEX4, S => output_uh);
		dezena_hora : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_uh, CV => "0011", V => HEX5, S => output_dh, Sreg => reg_dh);
		
		process(reg_dh)
			begin
				if(reg_dh = "0010") then
					cv_uh <= "0100";
				else
					cv_uh <= "1010";
				end if;
		end process;
		
	end FSMtopLevel_architecture;
