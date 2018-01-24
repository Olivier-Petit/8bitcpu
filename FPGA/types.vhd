library ieee;
use ieee.std_logic_1164.all ;

package types is

	type control_word is 
	record
		HALT : std_logic;
		AI : std_logic; -- A register in
		AO : std_logic; -- A register out
		BI : std_logic; -- B register in
		BO : std_logic; -- B register out
		PCO : std_logic; -- Program counter out
		PCI : std_logic; -- Program counter in
		PCE : std_logic; -- Program counter enable
		ADDRI : std_logic; -- Memory address register in
		MI : std_logic; -- Memory in (write)
		MO : std_logic; -- Memory out
		EO : std_logic; -- ALU out
		SUB : std_logic; -- ALU substract
		II : std_logic; -- Instruction register in
		IO : std_logic; -- Instruction register out
		DO : std_logic; -- Display out
	end record;
	
	type ws2812b_color_type is array(natural range <>) of std_logic_vector(2 downto 0);
	
	constant WS_WHITE 	: std_logic_vector(2 downto 0) := "000";
	constant WS_RED 		: std_logic_vector(2 downto 0) := "001";
	constant WS_GREEN 	: std_logic_vector(2 downto 0) := "010";
	constant WS_BLUE 		: std_logic_vector(2 downto 0) := "011";
	constant WS_YELLOW 	: std_logic_vector(2 downto 0) := "100";
	constant WS_PURPLE	: std_logic_vector(2 downto 0) := "101";
	constant WS_CYAN 		: std_logic_vector(2 downto 0) := "110";
	
	
	type seven_seg_driver_input_type is array(natural range<>) of std_logic_vector(3 downto 0);
	
	type seven_seg_segments is 
	record
		A : std_logic;
		B : std_logic;
		C : std_logic;
		D : std_logic;
		E : std_logic;
		F : std_logic;
		G : std_logic;
	end record;
	
end package types ;
