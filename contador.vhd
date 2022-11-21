LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY contador IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        out_div : out STD_LOGIC_VECTOR (20 DOWNTO 0)
    );
END contador;

ARCHITECTURE contador OF contador IS

    SIGNAL cnt : STD_LOGIC_VECTOR (20 DOWNTO 0);
    SIGNAL cntr : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL square : STD_LOGIC;
    SIGNAL div : std_logic_vector (20 DOWNTO 0);

BEGIN

    PROCESS (clock, reset)
    BEGIN
        if reset = '1' THEN
            cnt <= (OTHERS => '0');
            cntr <= (OTHERS => '0');
        elsif (rising_edge(clock)) then
            cnt <= cnt + '1';
                if cnt = x"17D7840" then
                    cntr <= cntr + '1';
                    cnt <= (OTHERS => '0');
                end if;

            CASE cntr IS
                WHEN "0000" => div <= "100110001001011010000"; 
                WHEN "0001" => div <= "011110100001001000000";
                WHEN "0010" => div <= "011011011101110100000";
                WHEN "0011" => div <= "011000011010100000000";
                WHEN "0100" => div <= "010101010111001100000";
                WHEN "0101" => div <= "010010010011111000000";
                WHEN "0110" => div <= "001111010000100100000";
                WHEN "0111" => div <= "001100001101010000000";
                WHEN "1000" => div <= "001001001001111100000";
                WHEN "1001" => div <= "000110000110101000000";
                WHEN "1010" => div <= "000011000011010100000";
                WHEN "1011" => div <= "000001100001101010000";
                WHEN "1100" => div <= "000000110000110101000";
                WHEN "1101" => div <= "000000010011100010000";
                WHEN "1110" => div <= "000000001001110001000";
                WHEN "1111" => div <= "000000000010011100010";
            END CASE;    
        end if;
    END PROCESS;
END contador;