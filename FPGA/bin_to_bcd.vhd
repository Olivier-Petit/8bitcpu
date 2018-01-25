library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bin_to_bcd is
	port(
		RESET : in std_logic;
		CLOCK_50 : in std_logic;
		BIN : in std_logic_vector(7 downto 0);
		BCD : out std_logic_vector(11 downto 0)
	);
end entity bin_to_bcd;