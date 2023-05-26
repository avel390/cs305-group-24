library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity infoDisplay is
	port(clk : in std_logic;
		pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		rom_mux_output : out std_logic);
end entity infoDisplay;

architecture behaviour of infoDisplay is
	SIGNAL rom_data		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL rom_address	: STD_LOGIC_VECTOR (8 DOWNTO 0);

	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			: STRING;
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file				: STRING;
		intended_device_family	: STRING;
		lpm_hint				: STRING;
		lpm_type				: STRING;
		numwords_a				: NATURAL;
		operation_mode			: STRING;
		outdata_aclr_a			: STRING;
		outdata_reg_a			: STRING;
		widthad_a				: NATURAL;
		width_a					: NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

BEGIN

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "tcgrom.mif",
		intended_device_family => "Cyclone III",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 512,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 9,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clk,
		address_a => rom_address,
		q_a => rom_data
	);
	
	process(clk, pixel_row, pixel_column)
		type intArray is array (0 to 4) of integer range 0 to 26;
		variable livesText : intArray := (14, 11, 26, 5, 23);
	begin
		if (unsigned(pixel_row) <= 7) then
			if (unsigned(pixel_column) <= 39) then
				rom_address <= std_logic_vector(to_unsigned(livesText(to_integer(unsigned(pixel_column)) mod 8), 6)) & pixel_column(2 downto 0);
			end if;
			rom_mux_output <= rom_data (to_integer(unsigned(not pixel_column(2 downto 0))));
		else
			rom_mux_output <= '0';
		end if;
	end process;
END architecture;