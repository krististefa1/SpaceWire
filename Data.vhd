library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Data1 is
    Port ( Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0);
           Dld : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC);
end Data1;

architecture Behavioral of Data1 is

begin
    process(clk, clr, Dld)
        begin
            if clr = '1' then
                Dout <= "00000000";
            elsif rising_edge(clk) then
                if Dld = '1' then--data load is received from the shift registers component
                    Dout <= Din;--grabs the 8 bits that are loaded into the shift registers
                end if;
            end if;
    end process;
end Behavioral;
