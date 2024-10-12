library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rcounter is
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
end entity rcounter;

architecture Behaviour of rcounter is
    signal count_value : INTEGER range min to max := min;
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            roll <= '0';
            count_value <= min;
        elsif (rising_edge(clk) and (enable = '1')) then
            if (count_value = modulo) then
                roll <= '1';
                count_value <= min;
            else 
                roll <= '0';
                count_value <= count_value + 1;
            end if;
        end if;
        
    end process;
    
    
    
end architecture Behaviour;