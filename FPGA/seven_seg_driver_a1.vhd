library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

architecture a1 of seven_seg_driver is
	signal clock_counter : unsigned(8 downto 0);
	signal clock_100k : std_logic;
	signal dig_counter : integer range 0 to N - 1;
	signal cycle_counter : integer range 1 to 8;
begin

	-- Generate approx 100kHz clock
	process(RESET, CLOCK_50)
	begin
		if RESET = '0' then
			clock_counter <= (others => '0');
		elsif rising_edge(CLOCK_50) then
			clock_counter <= clock_counter + 1;
		end if;
	end process;
	
	clock_100k <= clock_counter(8);
	
	-- Generate counters for digit/cycle
	process(RESET, clock_100k)
	begin
		if RESET = '0' then
			dig_counter <= 0;
			cycle_counter <= 0;
		elsif rising_edge(clock_100k) then
		
			if dig_counter = (N - 1) then
				dig_counter <= 0;
				cycle_counter <= cycle_counter + 1;
			else
				dig_counter <= dig_counter + 1;
			end if;
			
			if cycle_counter = 8 then
				cycle_counter <= 1;
			end if;
		end if;
	end process;
	
	-- Output generation
	process(dig_counter, cycle_counter, INPUT, ENABLE, BRIGHTNESS)
		variable dig_enable : std_logic;
		variable dig_others : std_logic;
		variable seg_enable : std_logic;
	begin
		-- Enable digit
		if ENABLE(dig_counter) = '1' and cycle_counter < to_integer(unsigned(BRIGHTNESS)) then
			if COMON_ANODE = '1' then
				dig_enable := '1';
			else
				dig_enable := '0';
			end if;
		else
			if COMON_ANODE = '1' then
				dig_enable := '0';
			else
				dig_enable := '1';
			end if;
		end if;
		
		if COMON_ANODE = '1' then
			dig_others := '0';
		else
			dig_others := '1';
		end if;
		
		OUTPUT_DIG <= (dig_counter => dig_enable, others => dig_others);
		
		-- Enable segments
		if COMON_ANODE = '1' then
			seg_enable := '0';
		else
			seg_enable := '1';
		end if;
		
		case INPUT(dig_counter) is
			when "0000" => -- 0
				OUTPUT_SEG <= (G => not seg_enable, others => seg_enable);
			when "0001" => -- 1
				OUTPUT_SEG <= (B => seg_enable, C => seg_enable, others => not seg_enable);
			when "0010" => -- 2
				OUTPUT_SEG <= (C => not seg_enable, F => not seg_enable, others => seg_enable);
			when "0011" => -- 3
				OUTPUT_SEG <= (E => not seg_enable, F => not seg_enable, others => seg_enable);
			when "0100" => -- 4
				OUTPUT_SEG <= (A => not seg_enable, E => not seg_enable, others => seg_enable);
			when "0101" => -- 5
				OUTPUT_SEG <= (C => not seg_enable, E => not seg_enable, others => seg_enable);
			when "0110" => -- 6
				OUTPUT_SEG <= (C => not seg_enable, others => seg_enable);
			when "0111" => -- 7
				OUTPUT_SEG <= (A => seg_enable, B => seg_enable, C => seg_enable, others => not seg_enable);
			when "1000" => -- 8
				OUTPUT_SEG <= (others => seg_enable);
			when "1001" => -- 9
				OUTPUT_SEG <= (E => not seg_enable, others => seg_enable);
			when "1010" => -- a
				OUTPUT_SEG <= (D => not seg_enable, others => seg_enable);
			when "1011" => -- b
				OUTPUT_SEG <= (A => not seg_enable, B => not seg_enable, others => seg_enable);
			when "1100" => -- c
				OUTPUT_SEG <= (A=> not seg_enable, B => not seg_enable, G => not seg_enable, others => seg_enable);
			when "1101" => -- d
				OUTPUT_SEG <= (A => not seg_enable, G => not seg_enable, others => seg_enable);
			when "1110" => -- e
				OUTPUT_SEG <= (B => not seg_enable, C => not seg_enable, others => seg_enable);
			when "1111" => -- f
				OUTPUT_SEG <= (B => not seg_enable, C => not seg_enable, D => not seg_enable, others => seg_enable);

		end case;
	end process;
	
end architecture a1;

--entity seven_seg_driver is
--	generic(
--		N : integer;
--		COMON_ANODE : std_logic
--	);
--	
--	port(
--		RESET : in std_logic;
--		CLOCK_50 : in std_logic;
--		ENABLE : in std_logic_vector(N-1 downto 0);
--		INPUT : in seven_seg_driver_input_type(0 to N-1);
--		OUTPUT_DIG : out std_logic_vector(N-1 downto 0);
--		OUTPUT_SEG : out seven_seg_segements
--	);
--end entity seven_seg_driver;