library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

architecture a1 of ram is
	signal mem_addr_reg : std_logic_vector(3 downto 0);
	signal mem_addr : std_logic_vector(3 downto 0);
	signal write_clock : std_logic;
	signal data_in : std_logic_vector(7 downto 0);
	
	type mem_16 is array (0 to 15) of std_logic_vector(7 downto 0);
	
	signal memory : mem_16;
	begin
	
	-- Memory address register
	process(RESET, CLOCK)
	begin
		if RESET = '0' then
			mem_addr_reg <= (others => '0');
		elsif rising_edge(CLOCK) then
			if ADDR_IN = '1' then
				mem_addr_reg <= BUS_R(3 downto 0);
			end if;
		end if;
	end process;
	
	-- Selects between adress register and manual programming address
	process(mem_addr_reg, PROGRAMING, PROG_ADDR)
	begin
		if PROGRAMING = '1' then
			mem_addr <= PROG_ADDR;
		else
			mem_addr <= mem_addr_reg;
		end if;
	end process;
	
	-- Adress register output
	ADDR_OUT <= mem_addr;
	-- Memory content output
	MEM_OUT <= memory(to_integer(unsigned(mem_addr)));
	
	-- Selects between main clock and manual programing clock
	process(CLOCK, PROGRAMING, PROG_WRITE, WRITE_ENABLE)
	begin
		if PROGRAMING = '1' then
			write_clock <= PROG_WRITE;
		else
			write_clock <= CLOCK and WRITE_ENABLE;
		end if;
	end process;
	
	-- Selects between bus and manual programing in
	process(BUS_R, PROGRAMING, PROG_VAL)
	begin
		if PROGRAMING = '1' then
			data_in <= PROG_VAL;
		else
			data_in <= BUS_R;
		end if;
	end process;
	
	-- Write
	process(write_clock)
	begin
		if rising_edge(write_clock) then
			memory(to_integer(unsigned(mem_addr))) <= data_in;
		end if;	
	end process;

end architecture a1;