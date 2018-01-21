library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

entity instruction_decoder is
	port(
		CLOCK : in std_logic;
		RESET : in std_logic;
		INSTR : in std_logic_vector(7 downto 0);
		
		MICRO_INSTR_COUNT : out std_logic_vector(2 downto 0);
		CONTROL_WORD_OUT : out control_word
	);
end entity instruction_decoder;