library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of bin_to_bcd is
	signal out_reg : std_logic_vector(11 downto 0);
	signal scratch : unsigned(19 downto 0);
	signal counter : integer range 0 to 8;
begin

	process(RESET, CLOCK_50)
		variable to_add : unsigned(19 downto 0) := (others => '0');
	begin
		if RESET = '0' then
			out_reg <= (others => '0');
			scratch <= (others => '0');
			counter <= 0;
		elsif rising_edge(CLOCK_50) then
			
			counter <= counter + 1;
			
			if counter = 0 then
				scratch(7 downto 0) <= unsigned(BIN);
			else
				if scratch(19 downto 16) > 4 then
					to_add := to_add + 768; -- 768 = (3 << 8)
				end if;
				
				if scratch(15 downto 12) > 4 then
					to_add := to_add + 48; -- 48 = (3 << 4)
				end if;
				
				if scratch(11 downto	8) > 4 then
					to_add := to_add + 3;
				end if;
				
				scratch <= shift_left(scratch + to_add, 1);
				
				if counter = 7 then
					out_reg <= std_logic_vector(shift_left(scratch + to_add, 1))(19 downto 8);
					counter <= 0;
				end if;
			end if;
		end if;
	end process;
	
	BCD <= out_reg;
end architecture a1;