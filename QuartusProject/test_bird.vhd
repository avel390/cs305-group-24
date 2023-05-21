library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_bird is
end entity test_bird;

architecture test of test_bird is
	signal t_enable, t_reset, t_clk, t_up : std_logic;
	signal t_ypos : std_logic_vector(8 downto 0);
	signal t_yvel : integer;
	
	component bird is
		port (enable, reset, clk, up : in std_logic;
			ypos : out std_logic_vector(8 downto 0));
	end component;
	begin 
		DUT: bird port map (t_enable, t_reset, t_clk, t_up, t_ypos);
		
		t_reset <= '0', '1' after 60 ns, '0' after 65 ns, '1' after 160 ns, '0' after 165 ns;
		t_enable <= '0', '1' after 120 ns;
		t_up <= '0', '1' after 240 ns, '0' after 245 ns;
		
		process
		begin
			wait for 1 ns;
			t_clk <= '0';
			wait for 1 ns;
			t_clk <= '1';
		end process;
end architecture test;