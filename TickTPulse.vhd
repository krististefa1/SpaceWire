
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TickTPulse is
    Port ( gotNULLin : in STD_LOGIC;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           gotNULLout : out STD_LOGIC);
end TickTPulse;

architecture Behavioral of TickTPulse is

signal gotNULL : std_logic;

begin

    process(gotNULLin, clock, reset)
    
        begin

            if reset = '1' then
                gotNULL <= '0'; --sets the output value to 0
            elsif (clock'event and clock = '1') then
                if gotNULLin = '1' then --if reciever sends gotNULL 
                    gotNULL <= '1'; --sets value high
                else
                    gotNULL <= gotNULL; --keeps value what ever it preveously was
                end if;
            end if;
    
    end process;
    gotNULLout <= gotNULL;  --sets the signal value to the output

end Behavioral;
