LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ir IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;

		ir : IN STD_LOGIC;

		intr : OUT STD_LOGIC;
		command : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rlt OF ir IS
	TYPE fsm_t IS (IDLE, LEAD_9, LEAD_4, DATA);
	-- attribute enum_encoding of fsm_t : type is "one-hot"; -- Testar se ok
	SIGNAL state : fsm_t;
	SIGNAL next_state : fsm_t;

	SIGNAL prev_ir : STD_LOGIC;
	SIGNAL ir_pos : STD_LOGIC;
	SIGNAL ir_neg : STD_LOGIC;
	SIGNAL ir_edg : STD_LOGIC;

	SIGNAL cntr_9 : STD_LOGIC;
	SIGNAL cntr_4 : STD_LOGIC;
	SIGNAL cntr_h : STD_LOGIC;
	SIGNAL cntr_l : STD_LOGIC;

	SIGNAL err_flag : STD_LOGIC;

	SIGNAL data_cnt : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL cntr : STD_LOGIC_VECTOR(18 DOWNTO 0);
	SIGNAL receive : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

	-- Detector de bordas
	ir_pos <= (NOT prev_ir) AND ir; -- Subida
	ir_neg <= prev_ir AND (NOT ir); -- Descida
	ir_edg <= ir_pos OR ir_neg; -- Qualquer uma das duas

	-- Verificação de contagem de tempo
	cntr_9 <= '1' WHEN (cntr > x"5BBA0") ELSE
		'0'; -- 450'000 pulsos
	cntr_4 <= '1' WHEN (cntr > x"25990" AND cntr < x"47C70") ELSE
		'0'; -- 225'000 pulsos
	cntr_h <= '1' WHEN (cntr > x"103C4" AND cntr < x"18C7C") ELSE
		'0'; --  84'375 pulsos
	cntr_l <= '1' WHEN (cntr > x"2904" AND cntr < x"B1BC") ELSE
		'0'; --  28'125 pulsos

	-- Armazenar valor antigo do IR para o detector de borda
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			prev_ir <= '0';
		ELSIF (rising_edge(clk)) THEN
			prev_ir <= ir;
		END IF;
	END PROCESS;

	-- F = 50.000.000 (50 MHz)
	-- p = 1/50MHz = 20 ns
	-- >>>> 9 ms
	-- c = 9 ms / 20 ns = 0.009/0.000000020 = 450'000
	-- 2^16 - 1 = 65536 - 1 = 65'535
	-- 2^17 - 1 = 13...
	-- 2^18 - 1 = 26x....
	-- 2^19 - 1 = 524'287
	-- Portanto, 19 bits é suficiente para armazenar a contagem até 450k
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			cntr <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (ir_edg = '1') THEN
				cntr <= (OTHERS => '0');
			ELSE
				cntr <= cntr + '1';
			END IF;
		END IF;
	END PROCESS;

	-- Decodificação de estados da máquina de estados
	PROCESS (state, ir, cntr_9, cntr_4, data_cnt, err_flag, prev_ir)
	BEGIN
		CASE(state) IS
			WHEN IDLE =>
			IF (ir = '0') THEN -- Aguarda pulso 0
				next_state <= LEAD_9;
			ELSE
				next_state <= IDLE;
			END IF;
			WHEN LEAD_9 =>
			-- ir_pos?
			IF (ir = '1') THEN -- Aguarda pulso 1
				IF (cntr_9 = '1') THEN -- Verifica se passou tempo correto
					next_state <= LEAD_4;
				ELSE
					next_state <= IDLE;
				END IF;
			ELSE
				next_state <= LEAD_9;
			END IF;
			WHEN LEAD_4 =>
			-- ir_neg?
			IF (ir = '0') THEN -- Aguarda pulso 0
				IF (cntr_4 = '1') THEN -- Verifica se passou tempo correto
					next_state <= DATA;
				ELSE
					next_state <= IDLE;
				END IF;
			ELSE
				next_state <= LEAD_4;
			END IF;
			WHEN DATA =>
			-- Volta para o aguardo quando finalizou a recepção ou ocorreu erro
			-- and ir_pos
			IF (data_cnt = x"20" AND ir = '1' AND prev_ir = '1') THEN
				next_state <= IDLE;
			ELSIF (err_flag = '1') THEN
				next_state <= IDLE;
			ELSE
				next_state <= DATA;
			END IF;
		END CASE;
	END PROCESS;

	-- Troca de estados da máquina de estados
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			state <= IDLE;
		ELSIF (rising_edge(clk)) THEN
			state <= next_state;
		END IF;
	END PROCESS;

	-- Controla a recepção de dados
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			receive <= (OTHERS => '0');
			err_flag <= '0';
			data_cnt <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (state = DATA) THEN
				IF (ir_pos = '1') THEN
					IF (cntr_l = '0') THEN
						err_flag <= '1';
					END IF;
				ELSIF (ir_neg = '1') THEN
					IF (cntr_h = '1') THEN
						receive(0) <= '1';
					ELSIF (cntr_l = '1') THEN
						receive(0) <= '0';
					ELSE
						err_flag <= '1';
					END IF;
					receive(31 DOWNTO 1) <= receive(30 DOWNTO 0);
					data_cnt <= data_cnt + '1';
				END IF;
			ELSE
				receive <= (OTHERS => '0');
				data_cnt <= (OTHERS => '0');
				err_flag <= '0';
			END IF;
		END IF;
	END PROCESS;

	-- Controla a saída
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			intr <= '0';
			command <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (data_cnt = x"20" AND ir = '1' AND prev_ir = '1' AND state = DATA) THEN
				command <= receive(15 DOWNTO 8);
				intr <= '1';
			ELSE
				intr <= '0';
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;