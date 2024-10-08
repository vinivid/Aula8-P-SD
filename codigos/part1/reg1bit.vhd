library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg1bit is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data : IN STD_LOGIC;
        q : OUT STD_LOGIC := '0'
    );
end entity reg1bit;

architecture Behaviour of reg1bit is
    signal buff : STD_LOGIC;
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            buff <= '0';
        elsif (rising_edge(clk)) then
            buff <= data;
        end if;
        
    end process;
    
    q <= buff;
    
end architecture Behaviour;