library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of reg is
	signal val_internal : std_logic_vector(7 downto 0);

	begin

	-- Input from bus
	process(RESET, CLOCK)
	begin
		if RESET = '0' then
			val_internal <= (others => '0');
		elsif rising_edge(CLOCK) then
			if IN_ENABLE = '1' then
				val_internal <= BUS_R;
			end if;
		end if;
	end process;
	
	-- Output
	OUT_VAL <= val_internal;
end architecture a1;