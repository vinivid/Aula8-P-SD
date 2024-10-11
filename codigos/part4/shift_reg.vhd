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
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (enable = '1') then
                word <= d;
            else 
                for i in 0 to word'length - 2 loop
                    word(i) <= word(i + 1);
                end loop;
            end if;
        end if;
        
    end process;
    
    d_out <= word(0);
    
end architecture Behaviour;