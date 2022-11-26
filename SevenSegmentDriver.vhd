LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY SevenSegmentDriver IS
	PORT (
		clk_i : IN STD_LOGIC;
		rst_ni : IN STD_LOGIC;

		en_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		dots_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		seg0_i : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		seg1_i : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		seg2_i : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		seg3_i : IN STD_LOGIC_VECTOR(6 DOWNTO 0);

		seg_no : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		sel_no : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF SevenSegmentDriver IS
	SIGNAL cntr : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL sel : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

	sel_no <= NOT (sel AND en_i);
	seg_no <= NOT seg;

	PROCESS (clk_i, rst_ni)
	BEGIN
		IF (rst_ni = '0') THEN
			cntr <= (OTHERS => '0');
		ELSIF (rising_edge(clk_i)) THEN
			cntr <= cntr + '1';
			IF (cntr = x"C350") THEN
				cntr <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk_i, rst_ni)
	BEGIN
		IF (rst_ni = '0') THEN
			sel <= "0001";
		ELSIF (rising_edge(clk_i)) THEN
			IF (cntr = (cntr'RANGE => '0')) THEN
				sel(3 DOWNTO 1) <= sel(2 DOWNTO 0);
				sel(0) <= sel(3);
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sel, seg0_i, seg1_i, seg2_i, seg3_i, dots_i)
	BEGIN
		CASE(sel) IS -- Concatenação
			WHEN "0001" => seg <= seg0_i & dots_i(0);
			WHEN "0010" => seg <= seg1_i & dots_i(1);
			WHEN "0100" => seg <= seg2_i & dots_i(2);
			WHEN "1000" => seg <= seg3_i & dots_i(3);
			WHEN OTHERS => seg <= (OTHERS => '0');
		END CASE;
	END PROCESS;

END ARCHITECTURE;