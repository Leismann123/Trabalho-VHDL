LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY SevenSegmentDecoder IS
	PORT (
		bcd_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF SevenSegmentDecoder IS
BEGIN

	--     a
	--  f     b
	--     g
	--  e     c
	--     d

	PROCESS (bcd_i)
	BEGIN
		CASE(bcd_i) IS
			WHEN "0000" => seg_o <= "1111110"; -- 0
			WHEN "0001" => seg_o <= "0110000"; -- 1
			WHEN "0010" => seg_o <= "1101101"; -- 2
			WHEN "0011" => seg_o <= "1111001"; -- 3
			WHEN "0100" => seg_o <= "0110011"; -- 4
			WHEN "0101" => seg_o <= "1011011"; -- 5
			WHEN "0110" => seg_o <= "1011111"; -- 6
			WHEN "0111" => seg_o <= "1110000"; -- 7
			WHEN "1000" => seg_o <= "1111111"; -- 8
			WHEN "1001" => seg_o <= "1111011"; -- 9
			WHEN "1010" => seg_o <= "1000110"; -- f
			WHEN "1011" => seg_o <= "1110111"; -- a
			WHEN "1110" => seg_o <= "0000110"; -- i
			WHEN "1111" => seg_o <= "0001110"; -- l
			WHEN OTHERS => seg_o <= "0000000"; -- nada
		END CASE;
	END PROCESS;

END ARCHITECTURE;