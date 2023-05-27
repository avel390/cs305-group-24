LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


entity LFSR is
	port ( clk, reset : IN std_logic;
		   LSFR_value :	OUT std_logic_vector(4 downto 0));
		   
end LSFR;

architecture behaviour of LFSR is
SIGNAL seed: std_logic_vector(4 downto 0) := "10000";
SIGNAL current_value: std_logic_vector(4 downto 0);
SIGNAL next_value: std_logic_vector(4 downto 0);
SIGNAL feedback : std_logic;
begin

value_gen : process (clk, reset)
begin
	if (rising_edge(clk)) then
		if (reset = '1') then
			current_value <= seed;
		else
			current_value <= next_value;
		end if;
	end if;
end process;

feedback <= current_value(3) xor current_value(2);
next_value <= feedback & current_value(4 downto 1);

LSFR_value <= current_value;

END behaviour;

	