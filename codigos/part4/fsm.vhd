library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        fsm
    );
end entity fsm;