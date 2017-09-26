library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMtopLevel is
	port (
			  -- Entradas (nomenclatura definida no arquivo ¨.qsf¨)
			  CLOCK_50 : in STD_LOGIC;
			  KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);   --chaves de contato momentaneo.
	--      SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);    --chaves liga/desliga.

			  -- Saidas da placa (nomenclatura definida no arquivo ¨.qsf¨)
			  LEDR : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
			  LEDG : out STD_LOGIC_VECTOR(8 DOWNTO 0)  := (others => '0');
			  HEX0 : OUT STD_LOGIC_VECTOR(6 downto 0)
		 );
end entity;


architecture FSMtopLevel_architecture of FSMtopLevel is
	signal ULA_IN_A, ULA_OUT, OUTPUT : std_logic_vector(3 downto 0) := "0000";
	signal overflowLocal  : std_logic;
	begin
		 counter : entity work.CountOneSec
				port map (clock => CLOCK_50, reset => '0', output => OUTPUT);
		 regSegundos : entity work.registrador
				generic map ( larguraDados => 4 )
				port map (DIN => ULA_OUT, DOUT => ULA_IN_A, CLK => CLOCK_50, RST => '0', ENABLE => '1');
		 ULA : entity work.ULA
				generic map ( larguraDados => 4 )
				port map (A => ULA_IN_A, B => OUTPUT, C => ULA_OUT, Sel => "00", overflow => overflowLocal);
		 display0 : entity work.conversorHex7seg
				port map (saida7seg => HEX0, dadoHex => ULA_IN_A, apaga => overflowLocal);
	end FSMtopLevel_architecture;
