LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY contador IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        intr : IN STD_LOGIC;
        command : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        cnt_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF contador IS

    SIGNAL cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    cnt_out <= cnt;

    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            cnt <= (OTHERS => '0');
        ELSIF (rising_edge(clock)) THEN
            IF intr = '1' THEN
                CASE command IS
                    WHEN x"68" =>
                        cnt <= "0000"; --0
                    WHEN x"30" =>
                        cnt <= "0001"; --1
                    WHEN x"18" =>
                        cnt <= "0010"; --2
                    WHEN x"7A" =>
                        cnt <= "0011"; --3
                    WHEN x"10" =>
                        cnt <= "0100"; --4
                    WHEN x"38" =>
                        cnt <= "0101"; --5
                    WHEN x"5A" =>
                        cnt <= "0110"; --6
                    WHEN x"42" =>
                        cnt <= "0111"; --7
                    WHEN x"4A" =>
                        cnt <= "1000"; --8
                    WHEN x"52" =>
                        cnt <= "1001"; --9
                    WHEN OTHERS =>
                        cnt <= cnt;
                END CASE;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;