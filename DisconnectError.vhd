library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity DisconnectError is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           enable : in STD_LOGIC;
           Q : in std_logic_vector(1 downto 0);
           Error : out STD_LOGIC);
end DisconnectError;

architecture Behavioral of DisconnectError is


signal temp: std_logic_vector(7 downto 0);
signal count: std_logic;
begin
    process(mclk, clr, enable, Q(1), Q(0))
        begin
        if clr = '1' then
            temp <= (others => '0');
            count <= '0';
        elsif rising_edge(mclk) then
            if enable = '1' then
                if Q(1) = Q(0) then --if the new bit is the same as the last data bit
                    if temp >= X"55" then --counts up to 85 which is 850ns at 100MHz
                        temp <= X"55"; --reset value when done
                        count <= '1';--used to output the disconnect error
                    else
                        temp <= temp + 1; --increments if it has not reached 850 ns
                        count <= '0';
                    end if;
                else
                    temp <= (others => '0'); --if the two bits are different then the count is reset
                end if;
            end if;
        end if;
    end process;
    Error <= count;--set the output high when 850ns has be reached
end Behavioral;
