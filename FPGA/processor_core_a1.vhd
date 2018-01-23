library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

architecture a1 of processor_core is
	signal bus_int : std_logic_vector(7 downto 0);
	signal reg_a_int : std_logic_vector(7 downto 0);
	signal reg_b_int : std_logic_vector(7 downto 0);
	signal reg_out_int : std_logic_vector(7 downto 0);
	signal pc_int : std_logic_vector(3 downto 0);
	signal alu_out_int : std_logic_vector(7 downto 0);
	signal carry_int : std_logic;
	signal ram_addr_int : std_logic_vector(3 downto 0);
	signal ram_val_int : std_logic_vector(7 downto 0);
	signal reg_instr_int : std_logic_vector(7 downto 0);
	signal control_int : control_word;
	signal micro_instr_count_int : std_logic_vector(2 downto 0);
	signal clock_act_int : std_logic;
	signal clock_int : std_logic;
	
	begin
	
	-- Clock/Halt signal handling
	clock_int <= CLOCK and clock_act_int;
	clock_act_int <= not control_int.HALT;
	
	-- Bus multiplexing
	process(
		control_int.AO, control_int.BO, control_int.PCO, 
		control_int.MO, control_int.EO, control_int.IO,
		reg_a_int, reg_b_int, alu_out_int, pc_int, ram_val_int, reg_instr_int)
	begin
		if control_int.AO = '1' then
			bus_int <= reg_a_int;
		elsif control_int.BO = '1' then
			bus_int <= reg_b_int;
		elsif control_int.PCO  = '1' then
			bus_int(7 downto 4) <= (others => '0');
			bus_int(3 downto 0) <= pc_int;
		elsif control_int.MO = '1' then
			bus_int <= ram_val_int;
		elsif control_int.EO = '1' then
			bus_int <= alu_out_int;
		elsif control_int.IO = '1' then
			bus_int(7 downto 4) <= (others => '0');
			bus_int(3 downto 0) <= reg_instr_int(3 downto 0);
		else
			bus_int <= (others => '0');
		end if;
	end process;
	
	-- Registers
	reg_a_r : entity work.reg(a1)
		port map(
			RESET => RESET,
			CLOCK => clock_int,
			OUT_VAL => reg_a_int,
			BUS_R => bus_int,
			IN_ENABLE => control_int.AI
		);
		
	reg_b_r : entity work.reg(a1)
		port map(
			RESET => RESET,
			CLOCK => clock_int,
			OUT_VAL => reg_b_int,
			BUS_R => bus_int,
			IN_ENABLE => control_int.BI
		);
	
	reg_instr_r : entity work.reg(a1)
		port map(
			RESET => RESET,
			CLOCK => clock_int,
			OUT_VAL => reg_instr_int,
			BUS_R => bus_int,
			IN_ENABLE => control_int.II
		);
	
	reg_out_r : entity work.reg(a1)
		port map(
			RESET => RESET,
			CLOCK => clock_int,
			OUT_VAL => reg_out_int,
			BUS_R => bus_int,
			IN_ENABLE => control_int.DO
		);
		
	-- ALU
	alu : entity work.alu(a1)
		port map(
			A_IN => reg_a_int,
			B_IN => reg_b_int,
			SUB => control_int.SUB,
			OUT_VAL => alu_out_int,
			CARRY => carry_int
		);
		
	-- RAM
	ram : entity work.ram(a1)
		port map(
			CLOCK => clock_int,
			RESET => RESET,
			ADDR_IN => control_int.ADDRI,
			ADDR_OUT => ram_addr_int,
			WRITE_ENABLE => control_int.MI,
			MEM_OUT => ram_val_int,
			BUS_R => bus_int,
			
			PROGRAMING => PROGRAM_MODE,
			PROG_ADDR => PROGRAM_ADDR,
			PROG_VAL => PROGRAM_VAL,
			PROG_WRITE => PROGRAM_WRITE
		
		);
		
	-- Instruction decoder
	instr_decode : entity work.instruction_decoder(a0)
		port map(
			CLOCK => clock_int,
			RESET => reset,
			INSTR => reg_instr_int,
			
			MICRO_INSTR_COUNT => micro_instr_count_int,
			CONTROL_WORD_OUT=> control_int
		);
	
--		HALT : std_logic;
--		AI : std_logic; -- A register in
--		AO : std_logic; -- A register out
--		BI : std_logic; -- B register in
--		BO : std_logic; -- B register out
--		PCO : std_logic; -- Program counter out
--		PCI : std_logic; -- Program counter in
--		PCE : std_logic; -- Program counter enable
--		ADDRI : std_logic; -- Memory address register in
--		MI : std_logic; -- Memory in (write)
--		MO : std_logic; -- Memory out
--		EO : std_logic; -- ALU out
--		SUB : std_logic; -- ALU substract
--		II : std_logic; -- Instruction register in
--		IO : std_logic; -- Instruction register out
--		DO : std_logic; -- Display out
		
--	port(
--		RESET : in std_logic;
--		CLOCK : in std_logic;
--		PROGRAM_MODE : in std_logic;
--		PROGRAM_ADDR : in std_logic_vector(3 downto 0);
--		PROGRAM_VAL : in std_logic_vector(7 downto 0);
--		
--		REG_A : out std_logic_vector(7 downto 0);
--		REG_B : out std_logic_vector(7 downto 0);
--		REG_OUT : out std_logic_vector(7 downto 0);
--		ALU_OUT : out std_logic_vector(7 downto 0);
--		CARRY : out std_logic;
--		RAM_ADDR : out std_logic_vector(3 downto 0);
--		RAM_VAL : out std_logic_vector(7 downto 0);
--		REG_INSTR : out std_logic_vector(7 downto 0);
--		CONTROL : out control_word;
--		CLOCK_ACT : out std_logic
--	);
end architecture a1;