library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity counter is
    Port ( clk : in STD_LOGIC;
           En : in STD_LOGIC;
           count : out STD_LOGIC;
           reset : in STD_LOGIC);
end counter;

architecture Behavioral of counter is

signal counter : std_logic_vector(3 downto 0);
signal wrap: std_logic;

begin--used by the FSM when loading the 8 bits for a data character

    process (reset, clk, En, counter, wrap)
    begin
        if reset = '1' then
            counter <= "0001";               
            wrap <= '0';
        elsif rising_edge(clk) then
            if En = '1' then
                if counter = "0110" then --only loads 6 bits because the other two are loaded
                    wrap <= '1';     --in different states
                    counter <= "0000";
                else
                    wrap <= '0';
                    counter <= counter + 1;
                end if;
            else
                wrap <= wrap;
            end if;
        end if;
    end process;
    
    count <= wrap;     
        
end Behavioral;
