library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMtopLevel is
	port (
			  -- Entradas (nomenclatura definida no arquivo ¨.qsf¨)
			  CLOCK_50 : in STD_LOGIC;
			  -- KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);   --chaves de contato momentaneo.
			  SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);    --chaves liga/desliga.

			  -- Saidas da placa (nomenclatura definida no arquivo ¨.qsf¨)
			  LEDR : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
			  LEDG : out STD_LOGIC_VECTOR(8 DOWNTO 0)  := (others => '0');
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: OUT STD_LOGIC_VECTOR(6 downto 0)
		 );
end entity;


architecture FSMtopLevel_architecture of FSMtopLevel is
	signal output_us,output_ds,output_um,output_dm,output_uh,output_dh,reg_dh,cv_uh, OUTPUT: std_logic_vector(3 downto 0) := (others=>'0');
	begin
		counter : entity work.CountOneSec
				port map (speed => SW(0),clock => CLOCK_50, reset => '0', output => OUTPUT);
		unidade_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => OUTPUT, CV => "1010", V => HEX0, S => output_us);
		dezena_segundo : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_us, CV => "0110", V => HEX1, S => output_ds);
		unidade_minuto : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_ds, CV => "1010", V => HEX2, S => output_um);
		dezena_minuto : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_um, CV => "0110", V => HEX3, S => output_dm);
		unidade_hora : entity work.tempo
				port map (CLOCK_50 => CLOCK_50, B => output_dm, CV => cv_uh, V => HEX4, S => output_uh);
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
