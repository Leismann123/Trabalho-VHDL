LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY main IS
    PORT (
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;

        ir : std_logic;

        sensor : in std_logic;

        led_n : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        buzzer_out : OUT STD_LOGIC
    );
END main;

ARCHITECTURE main OF main IS
	
    SIGNAL btn1_deb : STD_LOGIC;
    SIGNAL btn1_sync : STD_LOGIC;
    SIGNAL btn1_n_sync : STD_LOGIC;

    SIGNAL cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cntr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL led : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL senha_s : std_logic_vector(1 downto 0);
        
    SIGNAL ir_sync : std_logic;    
    SIGNAL reset : std_logic;
    SIGNAL v_test : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL command : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --SIGNAL command_en : STD_LOGIC;

    SIGNAL div : std_logic_vector(20 downto 0);

    signal intr		: std_logic;

    SIGNAL buzzer : STD_LOGIC;

BEGIN


    reset    <= not reset_n;
    led_n    <= not led;

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
    
    contador : ENTITY work.contador
        PORT MAP(
            clock => clock,
            reset => reset,
            out_div => div
        );

    buzz : ENTITY work.buzzer
        PORT MAP(
            clock => clock,
            reset => reset,
            in_div => div,
            buzzer_en => buzzer,
            buzzer_out => buzzer_out
        );  

    central : ENTITY work.central
        PORT MAP(
            clock => clock,
            reset => reset,
            sensor => btn1_deb,
            led => led,
            senha => senha_s,
            s_buzzer => buzzer,
            intr => intr
        );

    senhas : ENTITY work.senha
        PORT MAP(
            clock => clock,
            reset => reset,
            ir => command,
            senha_c => senha_s,
            intr => intr
        );

    END main;