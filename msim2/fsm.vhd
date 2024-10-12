library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        word : IN STD_LOGIC_VECTOR(2 downto 0);
        led : OUT STD_LOGIC
    );
end entity fsm;

architecture Behaviour of fsm is
    component counter is
        generic (
            modulo : INTEGER := 4;
            max : INTEGER := 4;
            min : INTEGER := 0
        );
        port (
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset : in STD_LOGIC;
            counter : buffer INTEGER range min to max := min
        );
    end component;

    component shift_reg is
        port (
            clk : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(3 downto 0);
            d_out : OUT STD_LOGIC := '0'
        );
    end component;

    component rcounter is
        generic (
            modulo : INTEGER := 4;
            min : INTEGER := 0;
            max : INTEGER := 8
        );
        port (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            roll : OUT STD_LOGIC
        );
    end component;

    --Estados da maquina de estados
    type state_type is (idle, shift, print_1p5, print_0p5, print_0p1);
    signal state : state_type := idle; --Inicia em idle pois esta esperando uma palavra

    --O estado da led
    signal led_state : std_logic := '0';

    --O tamanho da palavra e quantas letras ja foram printadas
    signal size : integer range 0 to 4;
    signal qtt_printed : integer range 0 to 4;
    
    --Sinais da shift register
    signal shift_assign : STD_LOGIC_VECTOR(3 downto 0);
    signal symbol : STD_LOGIC;
    signal shift_enable : STD_LOGIC := '0';
    signal shift_reset : STD_LOGIC := '0';

    --Sinais dos clocks
    signal clock5_enable : std_logic;
    signal clock5_reset : std_logic;
    signal clock5_roll : std_logic;

    signal clock1p5_enable : std_logic;
    signal clock1p5_reset : std_logic;
    signal clock1p5_roll : std_logic;

    signal clock1_enable : std_logic;
    signal clock1_reset : std_logic;
    signal clock1_roll : std_logic;

    signal curr_symbol : std_logic;
begin
    shift_re: shift_reg
     port map(
        clk => clk,
        enable => shift_enable,
        reset => shift_reset,
        d => shift_assign,
        d_out => symbol
    );
    
    --25000000
    c0p5: rcounter
     generic map(
        modulo => 2,
        min => 0,
        max => 30000000
    )
     port map(
        clk => clk,
        reset => clock5_reset,
        enable => clock5_enable,
        roll => clock5_roll
    );
    --75000000
    c1p5: rcounter
     generic map(
        modulo => 3,
        min => 0,
        max => 80000000
    )
     port map(
        clk => clk,
        reset => clock1p5_reset,
        enable => clock1p5_enable,
        roll => clock1p5_roll
    );
    --5000000
    c0p1: rcounter
     generic map(
        modulo => 1,
        min => 0,
        max => 6000000
    )
     port map(
        clk => clk,
        reset => clock1_reset,
        enable => clock1_enable,
        roll => clock1_roll
    );

    --pontos sao 0 e linhas sao 1 
    process (clk, reset)
    begin
        if (reset = '0') then
		clock1_reset <= '1';
		clock5_reset <= '1';
		clock1p5_reset <= '1';
		shift_reset <= '1';
		led_state <= '0';
		state <= idle;
        elsif (rising_edge(clk)) then
            case state is
                when idle =>
                    led_state <= '0';
		    shift_enable <= '0';
			 shift_reset <= '0';

                    if (enable = '0') then
                        case word is
                            when "000" =>
				shift_reset <= '1';
                                size <= 2;
                                shift_assign <= "0100";
				curr_symbol <= '0';
                                state <= shift;
                            when "001" => 
		    		shift_reset <= '1';
                                size <= 4;
                                shift_assign <= "1000";
				curr_symbol <= '1';
                                state <= shift;
                            when "010" =>
		    		shift_reset <= '1';
                                size <= 4;
                                shift_assign <= "1010";
				curr_symbol <= '1';
                                state <= shift;
                            when "011" => 
		    		shift_reset <= '1';
                                size <= 3;
                                shift_assign <= "1000";
				curr_symbol <= '1';
                                state <= shift;
                            when "100" => 
		    		shift_reset <= '1';
                                size <= 1;
                                shift_assign <= "0000";
				curr_symbol <= '0';
                                state <= shift;
                            when "101" => 
		    		shift_reset <= '1';
                                size <= 4;
                                shift_assign <= "0010";
				curr_symbol <= '0';
                                state <= shift;
                            when "110" => 
		    		shift_reset <= '1';
                                size <= 3;
                                shift_assign <= "1100";
				curr_symbol <= '1';
                                state <= shift;
                            when "111" => 
		    		shift_reset <= '1';
                                size <= 4;
                                shift_assign <= "0000";
				curr_symbol <= '0';
                                state <= shift;
			    when others =>
		    		shift_reset <= '1';
				size <= 0;
                                shift_assign <= "0000";
				curr_symbol <= '0';
                                state <= idle;
                        end case; 
                    end if;
                when shift =>
                    --Desabilitando todos os contadores e a shift register
		    shift_reset <= '0';
                    clock1_enable <= '0';
                    clock5_enable <= '0';
                    clock1p5_enable <= '0';

                    --Resetando todos os contadores
                    clock1_reset <= '1';
                    clock5_reset <= '1';
                    clock1p5_reset <= '1';
		
                    led_state <= '0';
							
		    shift_enable <= '1';

                    if (qtt_printed = size) then
                        shift_enable <= '0';
                        shift_reset <= '1';
			qtt_printed <= 0;
                        state <= idle;
                    elsif (curr_symbol = '1') then
                        state <= print_1p5; 
                    else 
                        state <= print_0p5; 
                    end if;
                when print_1p5 =>
		    shift_enable <= '0';
		    shift_reset <= '0';
                    clock1p5_reset <= '0';
                    clock1p5_enable <= '1';

                    led_state <= '1';

                    if (clock1p5_roll = '1') then
                        state <= print_0p1;
                    end if;
                when print_0p5 =>
		    shift_enable <= '0';
		    shift_reset <= '0';
                    clock5_reset <= '0';
                    clock5_enable <= '1'; 

                    led_state <= '1';
                    
                    if (clock5_roll = '1') then
                        state <= print_0p1;
                    end if;
                when print_0p1 =>
		    shift_enable <= '0';
		    shift_reset <= '0';
                    clock1_reset <= '0';
                    clock1_enable <= '1';

                    led_state <= '0';

                    if (clock1_roll = '1') then
			curr_symbol <= symbol;
			qtt_printed <= qtt_printed + 1;
                        state <= shift;
                    end if;
            end case;
        end if;
    end process;
    
    led <= led_state;

end architecture Behaviour;