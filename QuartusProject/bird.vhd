library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- updates bird position signal
-- clk should match framerate i.e. 60x per sec
-- 'up' input intended to connect to mouse click

entity bird is
	port (enable, reset, clk, up : in std_logic;
		ypos : out std_logic_vector(8 downto 0));
end entity bird;

architecture behaviour of bird is
	function max(a, b : in integer) return integer is -- get max of two integers
		variable max_value : integer;
	begin
		if (a > b) then
			max_value := a;
		else
			max_value := b;
		end if;
	
		return max_value;
	end function max;

	function min(a, b : in integer) return integer is -- get min of two integers
		variable min_value : integer;
	begin
		if (a < b) then
			min_value := a;
		else
			min_value := b;
		end if;
	
		return min_value;
	end function min;
begin
	process(enable, reset, clk, up)
		variable v_ypos : std_logic_vector(8 downto 0) := "011110000";
		variable v_yvel : integer := 0;
	begin
		if (reset = '1') then
			v_ypos := "011110000"; -- center bird to 240
			v_yvel := 0; -- set vertical speed to 0
		elsif (rising_edge(clk)) then
			if (enable = '1') then
				if (up = '1') then -- if up input is received, bird vel is up, else down
					v_yvel := 60;
				else
					v_yvel := v_yvel - 1;
				end if;
				
				if (v_yvel > 0) then -- move position, while checking bounds
					v_ypos := std_logic_vector(to_unsigned(min(to_integer(unsigned(v_ypos)) + v_yvel/10, 480), 9));
				else
					v_ypos := std_logic_vector(to_unsigned(max(to_integer(unsigned(v_ypos)) + v_yvel/10, 0), 9));
				end if;
			end if;
		end if;
		ypos <= v_ypos; -- update signal
	end process;
end architecture behaviour;