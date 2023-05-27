library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity pipe_display is
    port (CLOCK: in std_logic;
          RED_OUT, GREEN_OUT, BLUE_OUT, HORIZ_SYNC_OUT, VERT_SYNC_OUT: in std_logic_vector(9 downto 0));
end entity;

architecture behaviour of pipe_display is
    component VGA_SYNC is
        port (clock_25Mhz, red, green, blue		                            : in STD_LOGIC;
              red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: out STD_LOGIC;
              pixel_row, pixel_column                                       : out STD_LOGIC_VECTOR(9 downto 0));
    end component;

    component pipes is
        port (clk 						: in std_logic;
              pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
              red, green, blue 			: out std_logic);		
    end component;

    signal clk1, r1, g1, b1: std_logic;
    signal r_o, g_o, b_o, hs_o, vs_o: std_logic;
    signal pr1, pc1: std_logic_vector(9 downto 0);
begin
    V1: VGA_SYNC
        port map(clock_25Mhz => clk1, red => r1, green => g1, blue => b1,
                 red_out => r_o, green_out => g_o, blue_out => b_o, horiz_sync_out => hs_o, vert_sync_out => vs_o,
                 pixel_row => pr1, pixel_column => pc1);
    
    P1: pipes
        port map(clk => clk1, pixel_row => pr1, pixel_column => pc1, red => r1, green => g1, blue => b1);
end architecture behaviour;