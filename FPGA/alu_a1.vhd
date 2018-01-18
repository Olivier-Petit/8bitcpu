library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of alu is
	signal val_internal : unsigned(8 downto 0);
	
	begin
	
	-- Add/Subtract
	process(A_IN, B_IN, SUB)
	begin
		if SUB = '1' then
			val_internal <= unsigned(A_IN) - unsigned(B_IN);
		else
			val_internal <= unsigned(A_IN) + unsigned(B_IN);
		end if;
	end process;
	
	-- Permanent output
	OUT_VAL <= std_logic_vector(val_internal(7 downto 0));
	CARRY <= val_internal(8);
	
	-- Bus output
	process(val_internal, OUT_ENABLE)
	begin
		if OUT_ENABLE = '1' then
			BUS_R <= std_logic_vector(val_internal(7 downto 0));
		else
			BUS_R <= (others => 'Z');
		end if;
	end process;

end architecture a1;