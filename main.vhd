LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY main IS
    PORT (
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;

        ir : STD_LOGIC;

        sensor : IN STD_LOGIC;

        led_n : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        buzzer_out : OUT STD_LOGIC;

        seg_no : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        sel_no : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END main;

ARCHITECTURE main OF main IS

    SIGNAL btn1_deb : STD_LOGIC;
    SIGNAL btn1_sync : STD_LOGIC;
    SIGNAL btn1_n_sync : STD_LOGIC;

    SIGNAL cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cntr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL led : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL senha_s : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL ir_sync : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL v_test : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL command : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL commando : STD_LOGIC_VECTOR(3 DOWNTO 0);

    --SIGNAL command_en : STD_LOGIC;

    SIGNAL senha_ok : STD_LOGIC;
    SIGNAL senha_fail : STD_LOGIC;

    SIGNAL intr : STD_LOGIC;

    SIGNAL buzzer : STD_LOGIC;

    -- display
    SIGNAL seg0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL seg1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL seg2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL seg3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL casa_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL casa_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL casa_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL casa_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ponto : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL en_i : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    reset <= NOT reset_n;
    led_n <= NOT led;

    --Botão teste
    synch_1 : ENTITY work.synch
        PORT MAP(
            clock => clock,
            async_i => sensor,
            sync_o => btn1_n_sync
        );
    debounce_1 : ENTITY work.debounce
        PORT MAP(
            clock => clock,
            reset => reset,
            bounce_i => btn1_sync,
            debounce_o => btn1_deb
        );
    --IR
    synch_2 : ENTITY work.synch
        PORT MAP(
            clock => clock,
            async_i => ir,
            sync_o => ir_sync
        );
    infra : ENTITY work.ir
        PORT MAP(
            clk => clock,
            rst => reset,
            ir => ir_sync,
            intr => intr,
            command => command
        );

    buzz : ENTITY work.buzzer
        PORT MAP(
            clock => clock,
            reset => reset,
            buzzer_en => buzzer,
            buzzer_out => buzzer_out
        );

    central : ENTITY work.central
        PORT MAP(
            clock => clock,
            reset => reset,
            sensor => btn1_deb,
            led => led,
            senha_ok => senha_ok,
            senha_f => senha_fail,
            s_buzzer => buzzer,
            intr => intr
        );

    contador : ENTITY work.contador
        PORT MAP(
            clock => clock,
            reset => reset,
            command => command,
            cnt_out => commando,
            intr => intr
        );

    senha : ENTITY work.senha
        PORT MAP(
            clock => clock,
            reset_n => reset_n,
            cnt_in => commando,
            senha_ok => senha_ok,
            senha_fail => senha_fail,
            intr => intr
        );

    dec0 : ENTITY work.SevenSegmentDecoder
        PORT MAP(
            bcd_i => commando,
            seg_o => seg0
        );

    driver : ENTITY work.SevenSegmentDriver
        PORT MAP(
            clk_i => clock,
            rst_ni => reset_n,
            en_i => en_i,
            dots_i => ponto,
            seg0_i => seg0,
            seg1_i => seg1,
            seg2_i => seg2,
            seg3_i => seg3,
            seg_no => seg_no,
            sel_no => sel_no
        );
END main;