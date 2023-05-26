library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- "start" signal is switch, turning switch off returns to "main menu" from "game over"
-- TrainingIn signal is switch, if high then training mode is enabled, updates value of TrainingOut only when in "main menu"
-- Mode is 3 switches as input, fsm chooses highest difficulty enabled
entity FSM is
	port (Start, TrainingIn, CollisionPipe, CollisionGround, Lifepack : in std_logic;
		Mode : in std_logic_vector(2 downto 0); 
		Difficulty : out std_logic_vector(1 downto 0);
		Enable, Reset, TrainingOut : out std_logic);
end entity FSM;

architecture behaviour of FSM is
begin
	process(Mode, CollisionPipe, CollisionGround, Lifepack)
		variable state : integer range 1 to 5 := 1;
		variable nextState : integer range 1 to 5 := 1;
		variable difficulty_V : std_logic_vector(1 downto 0) := "01";
	begin
		case state is
			when 1 => -- "main menu"
				-- Check state change conditions
				if (Start = '1') then
					nextState := 2;
				end if;
				
				-- Perform tasks for current state
				-- Check selected difficulty
				if (unsigned(Mode) >= 4) then
					difficulty_V := "11";
				elsif (unsigned(Mode) >= 2) then
					difficulty_V := "10";
				else
					difficulty_V := "01";
				end if;
				-- Output signals for current state
				TrainingOut <= TrainingIn;
				Enable <= '0';
				Reset <= '1';
			when 2 => -- 3 hearts
				-- Check state change conditions
				if (CollisionGround = '1') then
					nextState := 5;
				elsif (CollisionPipe = '1') then
					nextState := 3;
				end if;
				
				-- Output signals for current state
				Enable <= '1';
				Reset <= '0';
			when 3 => -- 2 hearts
				-- Check state change conditions
				if (CollisionGround = '1') then
					nextState := 5;
				elsif (CollisionPipe = '1') then
					nextState := 4;
				elsif (Lifepack = '1') then
					nextState := 2;
				end if;
				
				-- Output signals for current state
				Enable <= '1';
				Reset <= '0';
			when 4 => -- 1 heart
				-- Check state change conditions
				if (CollisionGround = '1') then
					nextState := 5;
				elsif (CollisionPipe = '1') then
					nextState := 5;
				elsif (Lifepack = '1') then
					nextState := 3;
				end if;
				
				-- Output signals for current state
				Enable <= '1';
				Reset <= '0';
			when 5 => -- "game over"
				-- Check state change conditions
				if (Start = '0') then
					nextState := 1;
				end if;
				
				-- Output signals for current state
				Enable <= '0';
				Reset <= '0';
		end case;
		state := nextState; -- Update state
		Difficulty <= difficulty_V; -- Update difficulty output signal
	end process;
end architecture behaviour;