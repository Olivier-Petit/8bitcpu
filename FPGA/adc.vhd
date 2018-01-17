library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adc is
	port
	(
		RESET : in std_logic;
		CLOCK_50 : in std_logic;
		
		ADC_CS_N : out std_logic;
		ADC_SADDR : out std_logic;
		ADC_SDAT : in std_logic;
		ADC_SCLCK : out std_logic;
		
		CHAN_0 : out std_logic_vector(11 downto 0)
	);

end entity adc;