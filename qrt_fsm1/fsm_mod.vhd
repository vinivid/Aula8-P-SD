library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_mod is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        w : IN STD_LOGIC;
        z : OUT STD_LOGIC;
        led : OUT STD_LOGIC_VECTOR(8 downto 0) := (others => '0')
    );
end entity fsm_mod;

architecture Behaviour of fsm_mod is
    component reg1bit is
        port (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            data : IN STD_LOGIC;
            q : OUT STD_LOGIC := '0'
        );
    end component;

    signal z_state : STD_LOGIC := '0';
    signal reg_signal : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    type state_type is (A, B, C, D, E, F, G, H, I);
    signal state : state_type := A;
begin

    ff0 : reg1bit port map(clk => clk, reset => '1', data => reg_signal(0), q => led(0));
    ff1 : reg1bit port map(clk => clk, reset => '1', data => reg_signal(1), q => led(1));
    ff2: reg1bit port map(clk => clk, reset => '1',data => reg_signal(2), q => led(2));
    ff3: reg1bit port map( clk => clk, reset => '1', data => reg_signal(3), q => led(3));
    ff4: reg1bit port map( clk => clk, reset => '1', data => reg_signal(4), q => led(4));
    ff5: reg1bit port map( clk => clk, reset => '1', data => reg_signal(5), q => led(5));
    ff6: reg1bit port map( clk => clk, reset => '1', data => reg_signal(6), q => led(6));
    ff7: reg1bit port map( clk => clk, reset => '1', data => reg_signal(7), q => led(7));
    ff8: reg1bit port map( clk => clk, reset => '1', data => reg_signal(8), q => led(8));
    ffz: reg1bit port map( clk => clk, reset => '1', data => z_state, q => z);

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0') then
                state <= A;
                reg_signal(0) <= '0';
                reg_signal(8 downto 1) <= (others => '0');
				z_state <= '0';
            else 
                case state is
                    when A =>
                        z_state <= '0'; 
                        reg_signal(8 downto 0) <= (others => '0');

                        if (w = '1') then
                            state <= F; 
                        else 
                            state <= B;
                        end if;
                    when B =>
                        z_state <= '0';
                        reg_signal(0) <= '1';
                        reg_signal(1) <= '1';
                        reg_signal(8 downto 2) <= (others => '0');

                        if (w = '1') then
                             state <= F;
                        else 
                            state <= C;
                        end if;
                    when C =>
                        z_state <= '0';
						reg_signal(0) <= '1';
                        reg_signal(1) <= '0';
                        reg_signal(2) <= '1';
                        reg_signal(8 downto 3) <= (others => '0');

                        if (w = '1') then
                            state <= F;
                        else 
                            state <= D;
                        end if;
                    when D =>
                        z_state <= '0';
						reg_signal(0) <= '1';
                        reg_signal(2 downto 1) <= (others => '0');
                        reg_signal(3) <= '1';
                        reg_signal(8 downto 4) <= (others => '0');

                        if (w = '1') then
                            state <= F; 
                        else
                            state <= E;
                        end if;
                    when E =>
                        z_state <= '1';
						reg_signal(0) <= '1';
                        reg_signal(3 downto 1) <= (others => '0');
                        reg_signal(4) <= '1';
                        reg_signal(8 downto 5) <= (others => '0');

                        if (w = '1') then
                            state <= F;
                        else
                            state <= E;
                        end if;
                    when F => 
                        z_state <= '0';
						reg_signal(0) <= '1';
                        reg_signal(4 downto 1) <= (others => '0');
                        reg_signal(5) <= '1';
                        reg_signal(8 downto 6) <= (others => '0');

                        if (w = '1') then
                            state <= G;
                        else 
                            state <= B;
                        end if;
                    when G =>
                        z_state <= '0';
						reg_signal(0) <= '1';
                        reg_signal(5 downto 1) <= (others => '0');
                        reg_signal(6) <= '1';
                        reg_signal(8 downto 7) <= (others => '0');

                        if (w = '1') then
                            state <= H;
                        else 
                            state <= B;
                        end if;
                    when H => 
                        z_state <= '0';
						reg_signal(0) <= '1';
                        reg_signal(6 downto 1) <= (others => '0');
                        reg_signal(7) <= '1';
                        reg_signal(8) <= '0';

                        if (w = '1') then
                            state <= I;
                        else 
                            state <= B;
                        end if;
                    when I => 
                        z_state <= '1';
						reg_signal(0) <= '1';
                        reg_signal(7 downto 1) <= (others => '0');
                        reg_signal(8) <= '1';

                        if (w = '1') then
                            state <= I;
                        else 
                            state <= B;
                        end if;
                end case; 
            end if;
        end if;
    end process;
    
end architecture Behaviour;