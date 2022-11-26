LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

entity projeto_ir_display_top is
    port (
        clk   : in std_logic;
        rst_n : in std_logic;
    -- ir
        ir : in std_logic;

        led_n  : out std_logic_vector(3 downto 0);
        saida_buzzer : out std_logic;
    -- display
        seg_no  : out std_logic_vector(7 downto 0);
		sel_no  : out std_logic_vector(3 downto 0)

    );
end entity;

architecture rtl of projeto_ir_display_top is
    
    -- display
    signal seg0 : std_logic_vector(6 downto 0);
	signal seg1 : std_logic_vector(6 downto 0);
	signal seg2 : std_logic_vector(6 downto 0);
	signal seg3 : std_logic_vector(6 downto 0);
    signal casa_0 : std_logic_vector(3 downto 0);
    signal casa_1 : std_logic_vector(3 downto 0);
    signal casa_2 : std_logic_vector(3 downto 0);
    signal casa_3 : std_logic_vector(3 downto 0);
    signal ponto : std_logic_vector(3 downto 0);
    signal en_i : std_logic_vector(3 downto 0);
    -- ir 
    signal buzz_ativo : std_logic;
    signal rst : std_logic;
    signal ir_sync : std_logic;
    signal intr : std_logic;
    signal led : std_logic_vector(3 downto 0);
    signal digito : std_logic_vector(3 downto 0);
    signal command : std_logic_vector(7 downto 0);
    signal div : std_logic_vector(20 downto 0);
    
    signal buz_en : std_logic;
   
begin

    rst <= not rst_n;
    led_n <= not led;

        PROCESS (casa_3, casa_2, casa_1)
    BEGIN
        IF (casa_3 /= (casa_3'RANGE => '0')) THEN
            en_i <= "1111";
        ELSIF (casa_2 /= (casa_2'RANGE => '0')) THEN
            en_i <= "0111";
        ELSIF (casa_1 /= (casa_1'RANGE => '0')) THEN
            en_i <= "0011";
        ELSE
            en_i <= "0001";
        END IF;
    END PROCESS;

    process(led)
    begin
        case led is
            when "0000" => 
                div <= "100110001001011010000"; -- 1250000 - 20hz
                casa_0 <= "0000"; 
                casa_1 <= "0010";
                casa_2 <= "0000";
                casa_3 <= "0000";
                ponto <= "0000";

            when "0001" => 
                div <= "011110100001001000000"; -- 1000000 - 25hz
                casa_0 <= "0101"; 
                casa_1 <= "0010";
                casa_2 <= "0000";
                casa_3 <= "0000";
                ponto <= "0000";
            when "0010" => 
                div <= "011011011101110100000"; -- 900000 - 27,7hz
                casa_0 <= "0111"; 
                casa_1 <= "0111";
                casa_2 <= "0010";
                casa_3 <= "0000";
                ponto <= "0010";
            when "0011" => 
                div <= "011000011010100000000"; -- 800000 - 31,2hz
                casa_0 <= "0010"; 
                casa_1 <= "0001";
                casa_2 <= "0011";
                casa_3 <= "0000";
                ponto <= "0010";
            when "0100" => 
                div <= "010101010111001100000"; -- 700000 - 35,7hz
                casa_0 <= "0111"; 
                casa_1 <= "0101";
                casa_2 <= "0011";
                casa_3 <= "0000";
                ponto <= "0010";
            when "0101" => 
                div <= "010010010011111000000"; -- 600000 - 41,6hz
                casa_0 <= "0110"; 
                casa_1 <= "0001";
                casa_2 <= "0100";
                casa_3 <= "0000";
                ponto <= "0010";
            when "0110" => 
                div <= "001111010000100100000"; -- 500000 - 50hz
                casa_0 <= "0000"; 
                casa_1 <= "0101";
                casa_2 <= "0000";
                casa_3 <= "0000";
                ponto <= "0000";
            when "0111" => 
                div <= "001100001101010000000"; -- 400000 - 62,5hz
                casa_0 <= "0101"; 
                casa_1 <= "0010";
                casa_2 <= "0110";
                casa_3 <= "0000";
                ponto <= "0010";
            when "1000" => 
                div <= "001001001001111100000"; -- 300000 - 83,3hz
                casa_0 <= "0011"; 
                casa_1 <= "0011";
                casa_2 <= "1000";
                casa_3 <= "0000";
                ponto <= "0010";
            when "1001" => 
                div <= "000110000110101000000"; -- 200000 - 125hz
                casa_0 <= "0101"; 
                casa_1 <= "0010";
                casa_2 <= "0001";
                casa_3 <= "0000";
                ponto <= "0000";
            when "1010" => 
                div <= "000011000011010100000"; -- 100000 -250hz
                casa_0 <= "0000"; 
                casa_1 <= "0101";
                casa_2 <= "0010";
                casa_3 <= "0000";
                ponto <= "0000";
            when "1011" => 
                div <= "000001100001101010000"; -- 50000 -500hz
                casa_0 <= "0000"; 
                casa_1 <= "0000";
                casa_2 <= "0101";
                casa_3 <= "0000";
                ponto <= "0000";
            when "1100" => 
                div <= "000000110000110101000"; -- 25000 -1.000hz
                casa_0 <= "1111"; 
                casa_1 <= "0001";
                casa_2 <= "0000";
                casa_3 <= "0000";
                ponto <= "0000";
            when "1101" => 
                div <= "000000010011100010000"; -- 10000 -2.500hz
                casa_0 <= "1111";  
                casa_1 <= "0101";
                casa_2 <= "0010";
                casa_3 <= "0000";
                ponto <= "0100";
            when "1110" => 
                div <= "000000001001110001000"; -- 5000 -5.000hz
                casa_0 <= "1111"; 
                casa_1 <= "0101";
                casa_2 <= "0000";
                casa_3 <= "0000";
                ponto <= "0000";
            when "1111" => 
                div <= "000000000010011100010"; -- 1250 -20.000hz
                casa_0 <= "1111"; 
                casa_1 <= "0000";
                casa_2 <= "0010";
                casa_3 <= "0000";
                ponto <= "0000";
        end case;
    end process;
 
    synchro : entity work.synchro
    port map(
        clk => clk,
        async_i => ir,
        sync_o => ir_sync
    );

    buzzer_alarme : entity work.buzzer_alarme
    port map(
        clk => clk,
        rst => rst,
        en => buz_en,
        buzz => saida_buzzer,
        div_i => div
    );

    contador : entity work.contador
    port map(
        clk => clk,
        rst => rst,
        intr => intr,
        com_buz => buz_en,
        command => command,
        led => led
    );   

    ir_drive : entity work.ir
    port map( 
        clk => clk,
        rst => rst,
        ir => ir_sync,
        intr => intr,
        command => command
    );      

    dec0 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => casa_0,
		seg_o => seg0
	);

	dec1 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => casa_1,
		seg_o => seg1
	);

	dec2 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => casa_2,
		seg_o => seg2
	);

	dec3 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => casa_3,
		seg_o => seg3
	);

	driver : entity work.SevenSegmentDriver
	port map(
		clk_i => clk,
		rst_ni => rst_n,
		en_i => en_i,
		dots_i => ponto,
		seg0_i => seg0,
		seg1_i => seg1,
		seg2_i => seg2,
		seg3_i => seg3,
		seg_no => seg_no,
		sel_no => sel_no 
	);
end architecture;