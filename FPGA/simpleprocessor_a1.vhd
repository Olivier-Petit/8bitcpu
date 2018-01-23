library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of simpleprocessor is
	-- Clock
	signal main_clock : std_logic;
	signal clock_slow : std_logic;
	signal clock_counter : integer range 0 to 50000000;
	signal clock_counter_threashold : integer range 0 to 50000000;
	signal osc_or_manual_clock : std_logic;
	
	signal adc_0_in : std_logic_vector(11 downto 0);
	
	begin
	
	osc_or_manual_clock <= (clock_slow and CLOCK_RUN) or not CLOCK_STEP;
	clock_counter_threashold <= to_integer(unsigned(adc_0_in)) * 6100 + 1;
	
	-- Generates a clock signal which speed is determined by adc input 0
	p_clock_slow : process(RESET, CLOCK_50)
	begin
		if RESET = '0' then
			clock_counter <= 0;
			clock_slow <= '0';
		elsif rising_edge(CLOCK_50) then
			if clock_counter > clock_counter_threashold then
				clock_counter <= 0;
				clock_slow <= not clock_slow;
			else
				clock_counter <= clock_counter + 1;
			end if;
		end if;
	end process;
	
	-- Generates the main clock (clock can be stoped and steped manually)
	p_clock : process(RESET, osc_or_manual_clock)
	begin
		if RESET = '0'  then
			main_clock <= '0';
	   elsif rising_edge(osc_or_manual_clock) then
			main_clock <= not main_clock;
		end if;
	end process;
	
	-- ADC instantiation
	adc : entity work.adc(a1)
		port map(
			RESET => RESET, 
			CLOCK_50 => CLOCK_50,
			ADC_CS_N => ADC_CS_N,
			ADC_SADDR => ADC_SADDR,
			ADC_SDAT => ADC_SDAT,
			ADC_SCLCK => ADC_SCLCK,
		
			CHAN_0 => adc_0_in
		);	
		
	-- CPU core 
	core : entity work.processor_core(a1)
		port map
		(
			RESET => RESET,
			CLOCK => main_clock,
			PROGRAM_MODE => PROG_EN,
			PROGRAM_ADDR => PROG_ADDR,
			PROGRAM_VAL=> PROG_VAL,
			PROGRAM_WRITE => PROG_W,
			
			REG_A => open,
			REG_B => open,
			REG_OUT => open,
			ALU_OUT => open,
			CARRY => open,
			RAM_ADDR => open,
			RAM_VAL => open,
			REG_INSTR => open,
			CONTROL => open,
			MICRO_INSTR_COUNT => open,
			CLOCK_ACT => open
		);
	--LED(7 downto 1) <= adc_0_in(11 downto 5);
	LED(0) <= main_clock;
	
end architecture a1;