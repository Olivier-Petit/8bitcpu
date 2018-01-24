library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

entity seven_seg_driver is
	generic(
		N : integer;
		COMON_ANODE : std_logic
	);
	
	port(
		RESET : in std_logic;
		CLOCK_50 : in std_logic;
		ENABLE : in std_logic_vector(N-1 downto 0);
		INPUT : in seven_seg_driver_input_type(0 to N-1);
		BRIGHTNESS : in std_logic_vector(2 downto 0);
		OUTPUT_DIG : out std_logic_vector(N-1 downto 0);
		OUTPUT_SEG : out seven_seg_segments
	);
end entity seven_seg_driver;