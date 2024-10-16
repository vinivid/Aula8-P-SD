library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_reg is
    port (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(3 downto 0);
        d_out : OUT STD_LOGIC := '0'
    );
end entity shift_reg;

architecture Behaviour of shift_reg is
    signal word : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            word <= d;
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                word <= word(2 downto 0) & word(3);
            end if;
        end if;
        
    end process;
    
    d_out <= word(3);
    
end architecture Behaviour;