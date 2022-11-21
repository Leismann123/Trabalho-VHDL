LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY central IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        sensor : in std_logic;
        intr : in std_logic;
        senha : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        led : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_buzzer : out std_logic
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
            if intr = '1' then
                CASE FSM IS
                    WHEN DESARMADO =>
                        buzzer <= '0';
                        cnt <= "0010";
                        cntr <= cntr + '1';
                        if senha = x"3" THEN
                            FSM <= ARMADO;
                        else
                            buzzer <= '1';
                            if cntr = x"17D7840" THEN
                                FSM <= DESARMADO;
                            END IF;
                        END IF;    
                    WHEN ARMADO =>     
                        cnt <= "0001";
                        buzzer <= '0';
                        cntr <= cntr + '1';
                        if sensor <= '1' THEN
                            FSM <= DISPARANDO;
                        END IF;
                        if senha = x"30" THEN
                            FSM <= DESARMADO;
                        else
                            buzzer <= '1';
                            if cntr = x"17D7840" THEN
                                FSM <= ARMADO;
                            end if;    
                        END IF;
                    WHEN DISPARANDO => 
                        buzzer <= '1';
                        cnt <= "1111";
                        if senha = x"30" THEN
                            FSM <= DESARMADO;
                        END IF; 
                END CASE;
            end if;
        END IF;
    END PROCESS;

END central;