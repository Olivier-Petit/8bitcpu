library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a0 of instruction_decoder is
	signal instr_count : unsigned(2 downto 0);
	
	begin
	
	-- Counter
	process(RESET, CLOCK)
	begin
		if RESET = '0' then
			instr_count <= (others => '0');
		elsif falling_edge(CLOCK) then -- Falling edge to avoid race condition with all registers
			instr_count <= instr_count + 1;
		end if;
	end process;
	
	MICRO_INSTR_COUNT <= std_logic_vector(instr_count);
	
	-- Instr decode
	process(instr_count, INSTR)
	begin
		if instr_count = 0 then
			CONTROL_WORD_OUT <= (PCO => '1', ADDRI => '1', others => '0');
		elsif instr_count = 1 then
			CONTROL_WORD_OUT <= (MO => '1', II => '1', PCE => '1', others => '0');
		else
			case INSTR(7 downto 4) is
				when "0001" => -- LDA
					if instr_count = 2 then 
						CONTROL_WORD_OUT <= (IO => '1', ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						CONTROL_WORD_OUT <= (MO => '1', AI => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
				when "0010" => -- LDI
					if instr_count= 2 then
						CONTROL_WORD_OUT <= (IO => '1', AI => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
				when "0011" => -- STA
					if instr_count = 2 then 
						CONTROL_WORD_OUT <= (IO => '1', ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						CONTROL_WORD_OUT <= (AO => '1', MI => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
				when "0100" => -- ADD
					if instr_count = 2 then 
						CONTROL_WORD_OUT <= (IO => '1', ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						CONTROL_WORD_OUT <= (MO => '1', BI => '1', others => '0');
					elsif instr_count = 4 then
						CONTROL_WORD_OUT <= (AI => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
				when "0101" => -- SUB
					if instr_count = 2 then 
						CONTROL_WORD_OUT <= (IO => '1', ADDRI => '1', others => '0');
					elsif instr_count = 3 then
						CONTROL_WORD_OUT <= (MO => '1', BI => '1', others => '0');
					elsif instr_count = 4 then
						CONTROL_WORD_OUT <= (AI => '1', SUB => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
					
				when "1101" => -- OUT
					if instr_count = 2 then
						CONTROL_WORD_OUT <= (AO => '1', DO => '1', others => '0');
					else
						CONTROL_WORD_OUT <= (others => '0');
					end if;
					
				when "1111" => -- HALT
					if instr_count = 2 then
						CONTROL_WORD_OUT <= (HALT => '1', others => '0');
					end if;
				when others =>
					CONTROL_WORD_OUT <= (others => '0');
			end case;
		end if;
	end process;

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