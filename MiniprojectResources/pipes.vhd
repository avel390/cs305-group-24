LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY pipes IS
	PORT (clk, vert_sync	        : IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END pipes;

architecture behavior of pipes is
    SIGNAL pipe_on					: std_logic;
    SIGNAL height 					: std_logic_vector(9 DOWNTO 0);
    SIGNAL width 					: std_logic_vector(9 DOWNTO 0);
    SIGNAL pipe_y_pos				: std_logic_vector(9 DOWNTO 0);
    SiGNAL pipe_x_pos				: std_logic_vector(10 DOWNTO 0);
    SIGNAL pipe_x_motion			: std_logic_vector(9 DOWNTO 0);
BEGIN
    height <= CONV_STD_LOGIC_VECTOR(20, 10);
    width <= CONV_STD_LOGIC_VECTOR(8, 10);
    -- pipe_x_pos and pipe_y_pos show the (x,y) for the centre of pipe
    pipe_x_pos <= CONV_STD_LOGIC_VECTOR(590, 11);

    pipe_on <= '1' when ( ('0' & pipe_x_pos <= '0' & pixel_column + width) and ('0' & pixel_column <= '0' & pipe_x_pos + width) 	-- x_pos - size <= pixel_column <= x_pos + size
                        and ('0' & pipe_y_pos <= pixel_row + height) and ('0' & pixel_row <= pipe_y_pos + height) )  else	-- y_pos - size <= pixel_row <= y_pos + size
                '0';

    -- Colours for pixel data on video signal
    Red <= not pipe_on;
    Green <= '1';
    Blue <= not pipe_on;

    pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(2, 10);

    Move_Pipe: process (vert_sync)
    begin
        -- Move pipe once every vertical sync
        if (rising_edge(vert_sync)) then
            -- Return to right side of the screen
            if ( ('0' & pipe_x_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
                pipe_x_pos <= CONV_STD_LOGIC_VECTOR(636,10);
            end if;
            -- Compute next pipe X position
            pipe_x_pos <= pipe_x_pos + pipe_x_motion;
        end if;
    end process Move_Pipe;
END behavior;
