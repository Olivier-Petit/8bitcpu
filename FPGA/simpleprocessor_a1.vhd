library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

architecture a1 of simpleprocessor is
	-- Clock
	signal main_clock : std_logic;
	signal clock_slow : std_logic;
	signal clock_counter : integer range 0 to 50000000;
	signal clock_counter_threashold : integer range 0 to 50000000;
	signal osc_or_manual_clock : std_logic;
	
	signal adc_0_in : std_logic_vector(11 downto 0);
	
	signal led_enable : unsigned(15 downto 0);
	signal led_color : ws2812b_color_type(0 to 10);
	
	signal seven_seg_in : seven_seg_driver_input_type(0 to 3);
	
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
			
			REG_A => open, --led_enable(40 downto 33), 
			REG_B => open, --led_enable(32 downto 25),
			REG_OUT => open,
			ALU_OUT => open, --led_enable(24 downto 17),
			CARRY => open, --led_enable(16),
			PC_OUT => open,
			RAM_ADDR => open,
			RAM_VAL => open,
			REG_INSTR => open,
			CONTROL => open,
			MICRO_INSTR_COUNT => open,
			CLOCK_ACT => open
		);
		
	process(RESET, main_clock)
	begin
		if RESET = '0'  then
			led_enable <= (others => '0');
	   elsif rising_edge(main_clock) then
			led_enable <= led_enable + 1;
		end if;
	end process;
	
		
	-- LED strip
	ws2812_strip : entity work.ws2812b_strip(a1)
		generic map
		(
			N => 11
		)
		
		port map
		(
			RESET => RESET,
			CLOCK_50 => CLOCK_50,
			ENABLE => std_logic_vector(led_enable)(10 downto 0),
			COLOR => led_color,
			BRIGHTNESS => std_logic_vector(led_enable)(3 downto 1),
			OUTPUT => LEDSTRIP
		);
	
	-- All leds blue
	led_color <= (
		0 => WS_WHITE, 1 => WS_RED, 2 => WS_GREEN, 
		3 => WS_BLUE, 4 => WS_PURPLE, 5 => WS_CYAN, 
		others => WS_YELLOW);
		
	-- Seven segment thing
	disp : entity work.seven_seg_driver(a1)
	generic map
	(
		N => 4,
		COMON_ANODE => '1'
	)
	
	port map
	(
		RESET => RESET,
		CLOCK_50 => CLOCK_50,
		ENABLE => "1111",
		INPUT => seven_seg_in,
		BRIGHTNESS => "111", --std_logic_vector(led_enable)(3 downto 1),
		OUTPUT_DIG => SV_DIGIT,
		OUTPUT_SEG => SV_SEG
	);
	
	seven_seg_in <= (
			3 => std_logic_vector(led_enable)(15 downto 12), 
			2 => std_logic_vector(led_enable)(11 downto 8),
			1 => std_logic_vector(led_enable)(7 downto 4),
			0 => std_logic_vector(led_enable)(3 downto 0));
	--LED(7 downto 1) <= adc_0_in(11 downto 5);
	LED(0) <= main_clock;
	
end architecture a1;