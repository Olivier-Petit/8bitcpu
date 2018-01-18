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
	
	-- Outbut to bus
	process(IN_ENABLE, OUT_ENABLE, val_internal)
	begin
		if IN_ENABLE = '0' and OUT_ENABLE = '1' then
			BUS_R <= val_internal;
		else
			BUS_R <= (others => 'Z');
		end if;
	end process;
	
	-- Always output value (used for ALU)
	OUT_VAL <= val_internal;
end architecture a1;