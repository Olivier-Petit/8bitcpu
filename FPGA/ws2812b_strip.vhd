library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

entity ws2812b_strip is

	generic(
		N : integer
	);
	
	port(
		RESET : in std_logic;
		CLOCK_50 : in std_logic;
		ENABLE : in std_logic_vector(N-1 downto 0);
		COLOR : in ws2812b_color_type(0 to N-1);
		OUTPUT : out std_logic
	);

end entity ws2812b_strip;

-- Colors
-- 0 : white
-- 1 : red
-- 2 : green
-- 3 : blue
-- 4 : yellow
-- 5 : purple
-- 6 : cyan


