LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY senha IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        ir : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        intr : in std_logic;

        senha_c : out std_logic_vector(1 downto 0)
    );
END senha;

ARCHITECTURE senha OF senha IS
    TYPE stateFSM IS (esperando, senha1, senha2, senha3, liberado);
    SIGNAL FSM : stateFSM;

    SIGNAL senha_1 : std_logic_vector(7 downto 0);
    SIGNAL senha_2 : std_logic_vector(7 downto 0);
    SIGNAL senha_3 : std_logic_vector(7 downto 0);
    SIGNAL senha_4 : std_logic_vector(7 downto 0);


BEGIN
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            senha_1 <= x"18";
            senha_2 <= x"7A";
            senha_3 <= x"42";
            senha_4 <= x"38";

        ELSIF rising_edge(clock) THEN
                CASE FSM IS
                    WHEN esperando =>
                         if intr = '1' then
                            if ir = senha_1 THEN
                                FSM <= senha1;
                            else
                                senha_c <= "01";
                                FSM <= esperando;
                            END IF;
                        END IF;       
                    WHEN senha1 =>     
                        if intr = '1' then
                            if ir = senha_2 THEN
                                FSM <= senha2;
                            else
                                senha_c <= "01";
                                FSM <= esperando;
                            END IF;
                        END IF;    
                    WHEN senha2 =>     
                        if intr = '1' then
                            if ir = senha_3 THEN
                                FSM <= senha3;
                            else
                                senha_c <= "01";
                                FSM <= esperando;
                            END IF;
                        END IF;    
                    WHEN senha3 =>     
                        if intr = '1' then
                            if ir = senha_4 THEN
                                FSM <= liberado;
                            else
                                senha_c <= "01";
                                FSM <= esperando;
                            END IF;
                        END IF;    
                    WHEN liberado =>     
                        senha_c <= "11";
                        FSM <= esperando;
                END CASE;
        END IF;
    END PROCESS;

END senha;