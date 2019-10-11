library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    Port ( Din : in STD_LOGIC;
           Dout : out STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           ld : in STD_LOGIC);
end Reg;

architecture Behavioral of Reg is

begin
    process(clk, clr, ld)
        begin
            if clr = '1' then
                Dout <= '0';
            elsif rising_edge(clk) then
                if ld <= '1' then
                    Dout <= Din;
                end if;
            end if;
    end process;

end Behavioral;
