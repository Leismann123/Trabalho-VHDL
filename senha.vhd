LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY senha IS
    PORT (
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;

        intr : IN STD_LOGIC;

        senha_ok : OUT STD_LOGIC;
        senha_fail : OUT STD_LOGIC;

        cnt_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE rtl OF senha IS

    --Senha
    SIGNAL senha_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL senha_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL senha_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL senha_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL en_i : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL reset : STD_LOGIC;

BEGIN

    reset <= NOT reset_n;

    PROCESS (senha_3, senha_2, senha_1)
    BEGIN
        IF (senha_3 /= (senha_3'RANGE => '0')) THEN
            en_i <= "1111";
        ELSIF (senha_2 /= (senha_2'RANGE => '0')) THEN
            en_i <= "0111";
        ELSIF (senha_1 /= (senha_1'RANGE => '0')) THEN
            en_i <= "0011";
        ELSE
            en_i <= "0001";
        END IF;
    END PROCESS;
    PROCESS (cnt_in)
    BEGIN
        IF intr = '1' THEN
            CASE cnt_in IS
                WHEN "0000" => --0
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0000";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0000";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0000";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0000";
                    END IF;

                WHEN "0001" => --1
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0001";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0001";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0001";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0001";
                    END IF;

                WHEN "0010" => --2
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0010";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0010";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0010";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0010";
                    END IF;

                WHEN "0011" => --3
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0011";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0011";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0011";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0011";
                    END IF;

                WHEN "0100" => --4
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0100";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0100";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0100";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0100";
                    END IF;

                WHEN "0101" => --5
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0101";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0101";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0101";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0101";
                    END IF;

                WHEN "0110" => --6
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0110";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0110";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0110";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0110";
                    END IF;

                WHEN "0111" => --7
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "0111";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "0111";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "0111";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "0111";
                    END IF;

                WHEN "1000" => --8
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "1000";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "1000";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "1000";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "1000";
                    END IF;

                WHEN "1001" => --9
                    IF senha_0 /= (senha_0'RANGE => '0') THEN
                        senha_0 <= "1001";
                    ELSIF senha_1 /= (senha_1'RANGE => '0') THEN
                        senha_1 <= "1001";
                    ELSIF senha_2 /= (senha_2'RANGE => '0') THEN
                        senha_2 <= "1001";
                    ELSIF senha_3 /= (senha_3'RANGE => '0') THEN
                        senha_3 <= "1001";
                    END IF;

            END CASE;

            IF senha_3 /= (senha_3'RANGE => '0') THEN
                IF senha_0 = "0010" AND senha_1 = "0011" AND senha_2 = "0111" AND senha_3 = "0101" THEN
                    senha_ok <= '1';
                    senha_fail <= '0';
                ELSE
                    senha_ok <= '0';
                    senha_fail <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;