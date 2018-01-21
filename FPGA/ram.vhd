library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ram is
	port
	(
		-- Processor signals
		CLOCK : in std_logic;
		RESET: in std_logic;
		ADDR_IN : in std_logic;
		ADDR_OUT : out std_logic_vector(3 downto 0);
		WRITE_ENABLE : in std_logic;
		MEM_OUT : out std_logic_vector(7 downto 0);
		BUS_R : in std_logic_vector(7 downto 0);
		
		-- Manual programing
		PROGRAMING : in std_logic;
		PROG_ADDR : in std_logic_vector(3 downto 0);
		PROG_VAL : in std_logic_vector(7 downto 0);
		PROG_WRITE : in std_logic
		
	);

end entity ram;