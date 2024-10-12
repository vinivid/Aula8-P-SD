library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        word : IN STD_LOGIC_VECTOR(2 downto 0)
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

    --Estados da maquina de estados
    type state_type is (idle, shift, print_a, print_b);
    signal state : state_type := idle; --Inicia em idle pois esta esperando uma palavra

    --O tamanho da palavra e quantas letras ja foram printadas
    signal size : integer range 1 to 4;
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

    signal clock15_enable : std_logic;
    
begin

    shift_re: shift_reg
     port map(
        clk => clk,
        enable => shift_enable,
        reset => reset,
        d => shift_assign,
        d_out => symbol
    );
    --pontos sao 0 e linhas sao 1 
    process (clk, reset)
        variable word_times : STD_LOGIC := '0';
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            case state is
                when idle =>
                    if (enable = '1') then
                        case word is
                            when "000" =>
                                size <= 2;
                                shift_assign <= "0010";
                                state <= shift;
                            when "001" => 
                                size <= 4;
                                shift_assign <= "0001";
                                state <= shift;
                            when "010" =>
                                size <= 4;
                                shift_assign <= "0101";
                                state <= shift;
                            when "011" => 
                                size <= 3;
                                shift_assign <= "0001";
                                state <= shift;
                            when "100" => 
                                size <= 1;
                                shift_assign <= "0000";
                                state <= shift;
                            when "101" => 
                                size <= 4;
                                shift_assign <= "0100";
                                state <= shift;
                            when "110" => 
                                size <= 3;
                                shift_assign <= "0011";
                                state <= shift;
                            when "111" => 
                                size <= 4;
                                shift_assign <= "0000";
                                state <= shift;
                        end case; 
                    end if;
                when shift =>
                    
            end case;
        end if;
    end process;
    
    
end architecture Behaviour;