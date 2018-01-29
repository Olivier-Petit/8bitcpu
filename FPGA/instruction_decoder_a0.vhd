library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a0 of instruction_decoder is
	signal instr_count : unsigned(2 downto 0);
	signal control_word_int : control_word;
	
	begin
	
	-- Counter
	process(RESET, CLOCK)
	begin
		if RESET = '0' then
			instr_count <= (others => '0');
		elsif falling_edge(CLOCK) then -- Falling edge to avoid race condition with all registers
			if control_word_int.INEXT = '1' then
				instr_count <= (others => '0');
			else
				instr_count <= instr_count + 1;
			end if;
		end if;
	end process;
	
	MICRO_INSTR_COUNT <= std_logic_vector(instr_count);
	
	-- Instr decode
	process(instr_count, INSTR)
	begin
		if instr_count = 0 then
			control_word_int <= (PCO|ADDRI => '1', others => '0');
		elsif instr_count = 1 then
			control_word_int <= (MO|II|PCE => '1', others => '0');
		else
			case INSTR(7 downto 4) is
				when "0001" => -- LDA
					if instr_count = 2 then 
						control_word_int <= (IO|ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						control_word_int <= (MO|AI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "0010" => -- LDI
					if instr_count= 2 then
						control_word_int <= (IO|AI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "0011" => -- STA
					if instr_count = 2 then 
						control_word_int <= (IO|ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						control_word_int <= (AO|MI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "0100" => -- ADD
					if instr_count = 2 then 
						control_word_int <= (IO|ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						control_word_int <= (MO|BI => '1', others => '0');
					elsif instr_count = 4 then
						control_word_int <= (EO|AI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "0101" => -- SUB
					if instr_count = 2 then 
						control_word_int <= (IO|ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						control_word_int <= (MO|BI => '1', others => '0');
					elsif instr_count = 4 then
						control_word_int <= (EO|AI|SUB|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "1011" => -- JUMP
					if instr_count = 2 then 
						control_word_int <= (IO|PCI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "1100" => -- IN
					if instr_count = 2 then
						control_word_int <= (UWAIT => '1', others => '0');
					elsif instr_count = 3 then
						control_word_int <= (DI|AI|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "1101" => -- OUT
					if instr_count = 2 then
						control_word_int <= (AO|DO|INEXT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
					
				when "1111" => -- HALT
					if instr_count = 2 then
						control_word_int <= (HALT => '1', others => '0');
					else
						control_word_int <= (others => '0');
					end if;
				when others =>
					control_word_int <= (others => '0');
			end case;
		end if;
	end process;
	
	CONTROL_WORD_OUT <= control_word_int;

--	PORT(
--		CLOCK : in std_logic;
--		RESET : in std_logic;
--		INSTR : in std_logic_vector(7 downto 0);
--		
--		MICRO_INSTR_COUNT : out std_logic_vector(2 downto 0);
--		
--		HALT : out std_logic;
--		AI : out std_logic; -- A register in
--		AO : out std_logic; -- A register out
--		BI : out std_logic; -- B register in
--		BO : out std_logic; -- B register out
--		PCO : out std_logic; -- Program counter out
--		PCI : out std_logic; -- Program counter in
--    PCE 
--		ADDRI : out std_logic; -- Memory address register in
--		MI : out std_logic; -- Memory in (write)
--		MO : out std_logic; -- Memory out
--		EO : out std_logic; -- ALU out
--		SUB : out std_logic; -- ALU substract
--		II : out std_logic; -- Instruction register in
--		IO : out std_logic; -- Instruction register out
--		DO : out std_logic -- Display out
--	);
end architecture a0;