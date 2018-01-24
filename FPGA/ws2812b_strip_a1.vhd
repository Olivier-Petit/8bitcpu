library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package wb2812b_a1_pkg is
	type colors_memory_type is array(0 to 6) of unsigned(23 downto 0);
end package;

use work.wb2812b_a1_pkg.all;

architecture a1 of ws2812b_strip is
	-- 24 bit colors, in GRB format
	constant colors : colors_memory_type := (
		"111111111111111111111111", -- White
		"000000001111111100000000", -- Red
		"111111110000000000000000", -- Green
		"000000000000000011111111", -- Blue
		"111111111111111100000000", -- Yellow
		"000000001111111111111111", -- Purple
		"111111110000000011111111" -- Cyan
	);
	
	signal bit_number : integer range 0 to 7; -- Bit currently being tranmited
	signal color_number : integer range 0 to 2; -- Color component being transmited
	signal led_number : integer range 0 to N - 1; -- Led being transmited
	signal clock_2_5 : std_logic; -- 10Mhz clock
	signal clock_counter : unsigned(3 downto 0); -- Counter to generate clock
	signal bit_counter : unsigned(7 downto 0);
	signal reset_mode : std_logic; -- Flag for strip reset state
	signal out_int : std_logic;
	
	begin
	
	-- Generates 2.5Mhz clock
	process(RESET, CLOCK_50)
	begin
		if RESET = '0' then
			clock_counter <= (others => '0');
		elsif rising_edge(CLOCK_50) then
			if clock_counter = "1010" then
				clock_counter <= (others => '0');
				clock_2_5 <= not clock_2_5;
			else
				clock_counter <= clock_counter + 1;
			end if;
		end if;
	end process;
	
	-- One bit = 1.2us = 3 clock cycles
	-- Reset = 60 us = 150 clock cycles
	process(RESET, clock_2_5)
	begin
		if RESET = '0' then
			bit_counter <= (others => '0');
			reset_mode <= '1';
			bit_number <= 0;
			led_number <= 0;
		elsif rising_edge(clock_2_5) then
			if reset_mode = '1' then
				if bit_counter = "10010110" then -- Count 0 to 150
					reset_mode <= '0';
					bit_counter <= (others => '0');
				else
					bit_counter <= bit_counter + 1;
				end if;
			else -- transmiting
				if bit_counter = "11" then -- Count 0 to 3
					bit_counter <= (others => '0');
					
					if bit_number = 7 then
						bit_number <= 0;
						color_number <= color_number + 1;
					else
						bit_number <= bit_number + 1;
					end if;
					
					if bit_number = 7 and color_number = 2 then
						color_number <= 0;
						led_number <= led_number + 1;
					end if;
					
					if led_number = (N - 1) and color_number = 2 and bit_number = 7 then
						reset_mode <= '1';
						led_number <= 0;
					end if;
				else
					bit_counter <= bit_counter + 1;
				end if;
			end if;
		end if;
	end process;
	
	-- Generate output signal
	process(reset_mode, clock_2_5)
	variable bit_to_transmit : std_logic;
	variable color_component : unsigned(7 downto 0);
	begin
		if reset_mode = '1' then
			out_int <= '0';
		elsif falling_edge(clock_2_5) then 
			if ENABLE(led_number) = '0' then
				bit_to_transmit := '0';
			else
				if color_number = 0 then -- Green
					color_component := colors(to_integer(unsigned(COLOR(led_number))))(23 downto 16);
				elsif color_number = 1 then -- Red
					color_component := colors(to_integer(unsigned(COLOR(led_number))))(15 downto 8);
				else -- Blue
					color_component := colors(to_integer(unsigned(COLOR(led_number))))(7 downto 0);
				end if;
				
				-- Shift right by 7 - BRIGHTNESS
				color_component := shift_right(color_component, 7 - to_integer(unsigned(BRIGHTNESS)));
				
				-- Send MSB first
				bit_to_transmit := color_component(7 - bit_number);
			end if;
			
			if bit_to_transmit = '0' then
				if bit_counter = "0" then
					out_int <= '1';
				else
					out_int <= '0';
				end if;
			else
				if bit_counter = "0" or bit_counter = "1" then
					out_int <= '1';
				else
					out_int <= '0';
				end if;
			end if;
		end if;
	end process;
	
	OUTPUT <= out_int;

end architecture a1;