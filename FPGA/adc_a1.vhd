library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of adc is
	signal clock_3 : std_logic;
	signal clock_counter : integer range 0 to 8;
	
	signal chan_0_in : std_logic_vector(11 downto 0);
	signal state: integer range 0 to 18;
begin
	-- Generates a 3.3 MHz clock
	p_clock : process(RESET, CLOCK_50)
	begin
		if(RESET = '0') then
			clock_counter <= 0;
			clock_3 <= '0';
		elsif rising_edge(CLOCK_50) then
			case clock_counter is
				when 8 => 
					clock_counter <= 0;
					clock_3 <= not clock_3;
				when others => 
					clock_counter <= clock_counter + 1;
			end case;
		end if;
	end process;
	
	ADC_SCLCK <= clock_3;
	
   --  Acquisition
	p_acquisition : process(RESET, clock_3)
	begin
		if(RESET = '0') then
			state <= 0;
			ADC_CS_N <= '1';
			chan_0_in <= (others => '0');
			CHAN_0 <= (others => '0');
		elsif falling_edge(clock_3) then
			state <= state + 1;
			
			case state is 
				when 0 => 
					ADC_CS_N <= '0';
					ADC_SADDR <= '0'; -- Do not care
				when 1 => ADC_SADDR <= '0'; -- Do not care
				when 2 => ADC_SADDR <= '0'; -- ADD2 (in0)
				when 3 => ADC_SADDR <= '0'; -- ADD1 (in0)
				when 4 => ADC_SADDR <= '0'; -- ADD0 (in0)
				when 5 => ADC_SADDR <= '0'; -- Do not care
				when 6 => ADC_SADDR <= '0'; -- Do not care
				when 7 => ADC_SADDR <= '0'; -- Do not care
				when 16 => ADC_CS_N <= '1';
				when 18 => state <= 0;
				when others => null;
			end case;
		elsif rising_edge(clock_3) then
			case state is
				when 5 => chan_0_in(11) <= ADC_SDAT;
				when 6 => chan_0_in(10) <= ADC_SDAT;
				when 7 => chan_0_in(9) <= ADC_SDAT;
				when 8 => chan_0_in(8) <= ADC_SDAT;
				when 9=> chan_0_in(7) <= ADC_SDAT;
				when 10 => chan_0_in(6) <= ADC_SDAT;
				when 11 => chan_0_in(5) <= ADC_SDAT;
				when 12 => chan_0_in(4) <= ADC_SDAT;
				when 13 => chan_0_in(3) <= ADC_SDAT;
				when 14 => chan_0_in(2) <= ADC_SDAT;
				when 15 => chan_0_in(1) <= ADC_SDAT;
				when 16 =>  chan_0_in(0) <= ADC_SDAT;
				when 17 => CHAN_0 <= chan_0_in;
				when others => null;
			end case;	
		end if;
	end process;
	
end architecture a1;