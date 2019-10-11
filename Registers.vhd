library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registers is
    Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           en : in std_logic;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC);
end Registers;

architecture Behavioral of Registers is

begin
    process(clk, clr)
        begin
            if clr = '1' then
                Q <= '0';
            elsif rising_edge(clk) then
                if en = '1' then
                    Q <= D;
                end if;
            end if;
    end process;
end Behavioral;
