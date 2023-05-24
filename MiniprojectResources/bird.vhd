LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird IS
	PORT
		( clk, vert_sync, left_button, reset	: IN std_logic;
          pixel_row, pixel_column				: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 						: OUT std_logic);		
END bird;

architecture behavior of bird is
SIGNAL bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0);

BEGIN

size <= CONV_STD_LOGIC_VECTOR(8,10);

bird_x_pos <= CONV_STD_LOGIC_VECTOR(200,11);


Red <= '1';

Green <= not bird_on;
Blue <=  not bird_on;

Move_Bird: process (vert_sync, left_button, reset)
begin
	if (rising_edge(vert_sync)) then
		if ( ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
			bird_on <= '0';
		elsif (ball_y_pos <= size) then
			bird_on <= '0';
		elsif (left_button <= '1') then
			bird_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
		else
			bird_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
		end if
		bird_y_pos <= bird_y_pos + bird_y_motion;
	end if
end process Move_Bird;

END behavior;