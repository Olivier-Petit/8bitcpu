library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alu is
	port
	(
		A_IN : in std_logic_vector(7 downto 0);
		B_IN : in std_logic_vector(7 downto 0);
		SUB : in std_logic;
		OUT_ENABLE : in std_logic;
		BUS_R : out std_logic_vector(7 downto 0);
		OUT_VAL : out std_logic_vector(7 downto 0);
		CARRY : out std_logic
	);

end entity alu;