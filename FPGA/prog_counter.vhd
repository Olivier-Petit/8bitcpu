library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity prog_counter is
	port
	(
		CLOCK : in std_logic;
		RESET : in std_logic;
		IN_ENABLE : in std_logic;
		COUNTER_ENABLE : in std_logic;
		BUS_R : inout std_logic_vector(3 downto 0);
		OUT_VAL : out std_logic_vector(3 downto 0)
	);

end entity prog_counter;