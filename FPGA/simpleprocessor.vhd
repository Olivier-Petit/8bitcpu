library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity simpleprocessor is
	port
	(
		-- Clock and reset
		RESET : in std_logic;
		CLOCK_50 : in std_logic;
		CLOCK_RUN : in std_logic;
		CLOCK_STEP : in std_logic;
		
		-- ADC
		ADC_CS_N : out std_logic;
		ADC_SADDR : out std_logic;
		ADC_SDAT : in std_logic;
		ADC_SCLCK : out std_logic;
		
		-- LEDS
		LED : out std_logic_vector(7 downto 0);
		LEDSTRIP : out std_logic;
		
		-- PROGRAMING
		PROG_EN : in std_logic;
		PROG_W : in std_logic;
		PROG_ADDR : in std_logic_vector(3 downto 0);
		PROG_VAL : in std_logic_vector(7 downto 0)
	);

end entity simpleprocessor;