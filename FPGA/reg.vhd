library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity reg is
	port
	(
		RESET : in std_logic;
		CLOCK : in std_logic;
		OUT_VAL : out std_logic_vector(7 downto 0);
		BUS_R : inout std_logic_vector(7 downto 0);
		IN_ENABLE : in std_logic;
		OUT_ENABLE : in std_logic
	);

end entity reg;