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
		variable new_scratch : unsigned(19 downto 0) := (others => '0');
	begin
		if RESET = '0' then
			out_reg <= (others => '0');
			scratch <= (others => '0');
			counter <= 0;
		elsif rising_edge(CLOCK_50) then
			
			counter <= counter + 1;
			
			if counter = 0 then
				scratch <= (others => '0');
				scratch(7 downto 0) <= unsigned(BIN);
			else
				to_add := (others => '0');
				
				if scratch(15 downto 12) > 4 then
					to_add := to_add + 12288; -- 12288 = 3 << (4 + 8)
				end if;
				
				if scratch(11 downto	8) > 4 then
					to_add := to_add + 768; -- 768 = 3 << (0 + 8)
				end if;
				
				new_scratch := shift_left(scratch + to_add, 1);
				scratch <= new_scratch;
				
				if counter = 8 then
					out_reg <= std_logic_vector(new_scratch)(19 downto 8);
					counter <= 0;
				end if;
			end if;
		end if;
	end process;

	BCD <= out_reg;
end architecture a1;