LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY central IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        sensor : IN STD_LOGIC;
        intr : IN STD_LOGIC;

        senha_ok : IN STD_LOGIC;
        senha_fail : IN STD_LOGIC;

        led : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_buzzer : OUT STD_LOGIC
    );
END central;

ARCHITECTURE central OF central IS
    TYPE stateFSM IS (DESARMADO, ARMADO, DISPARANDO);
    SIGNAL FSM : stateFSM;

    SIGNAL cnt : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL cntr : STD_LOGIC_VECTOR (20 DOWNTO 0);
    SIGNAL buzzer : STD_LOGIC;

BEGIN
    s_buzzer <= buzzer;
    led <= cnt;
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            cnt <= (OTHERS => '0');
            cntr <= (OTHERS => '0');
            buzzer <= '0';
            FSM <= DESARMADO;
        ELSIF rising_edge(clock) THEN
            CASE FSM IS
                WHEN DESARMADO =>
                    buzzer <= '0';
                    cnt <= "0010";
                    cntr <= cntr + '1';
                    IF intr = '1' THEN
                        IF senha_ok = '1' then
                            FSM <= ARMADO;
                        ELSIF senha_fail = '1' THEN
                            buzzer <= '1';
                            IF cntr = x"17D7840" THEN
                                FSM <= DESARMADO;
                            END IF;
                        END IF;
                    END IF;
                WHEN ARMADO =>
                    cnt <= "0001";
                    buzzer <= '0';
                    cntr <= cntr + '1';
                    IF sensor <= '1' THEN
                        FSM <= DISPARANDO;
                    END IF;
                    IF intr = '1' THEN
                        IF senha_ok = '1' THEN
                            FSM <= DESARMADO;
                        ELSIF senha_fail = "1" THEN
                            buzzer <= '1';
                            IF cntr = x"17D7840" THEN
                                FSM <= ARMADO;
                            END IF;
                        END IF;
                    END IF;
                WHEN DISPARANDO =>
                    buzzer <= '1';
                    cnt <= "1111";
                    IF intr = '1' THEN
                        IF senha_ok = '1' THEN
                            FSM <= DESARMADO;
                        ELSIF senha_fail = '1' THEN
                            FSM <= DISPARANDO;
                        END IF;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

END central;