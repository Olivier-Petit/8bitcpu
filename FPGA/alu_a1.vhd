library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of alu is
	signal val_internal : unsigned(8 downto 0);
	signal a_internal : unsigned(8 downto 0);
	signal b_internal : unsigned(8 downto 0);
	
	begin
	
	a_internal(7 downto 0) <= unsigned(A_IN);
	a_internal(8) <= '0';
	
	b_internal(7 downto 0) <= unsigned(B_IN);
	b_internal(8) <= '0';
	
	-- Add/Subtract
	process(a_internal, b_internal, SUB)
	begin
		if SUB = '1' then
			val_internal <= a_internal - b_internal;
		else
			val_internal <= a_internal + b_internal;
		end if;
	end process;
	
	-- Output
	OUT_VAL <= std_logic_vector(val_internal(7 downto 0));
	CARRY <= val_internal(8);

end architecture a1;