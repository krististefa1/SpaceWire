library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Timer is --currently made to run on a 100MHz clock cycle
    Port ( clk : in STD_LOGIC;
           E : in STD_LOGIC;
           En : in STD_LOGIC;
           clk_out : out STD_LOGIC;
           clk_out2 : out STD_LOGIC;
           resetn : in STD_LOGIC);
           
end Timer;

architecture Behavioral of Timer is
signal count: std_logic_vector (9 downto 0) := "0000000000"; --going up to 640 which requires 10 digits
signal count2 : std_logic_vector (10 downto 0) := "00000000000"; --going up to 1280 which requires 11 digits
signal wrap: std_logic := '0';--used in 6.4 us timer
signal wrap2: std_logic := '0';--used in 12.8us timer

begin

    process (resetn, clk)
    begin
        if resetn = '1' then --resets the count values
            count <= (others => '0'); 
            count2 <= (others => '0');
            wrap <= '0';
            wrap2 <= '0';
        elsif (clk'event and clk = '1') then
            if E = '1' then 
                    --if statement for when the 6.4 us timer is started
                if count = "1010000000" then --640 cycles in 6.4 us at 100MHz
                    wrap <= '1'; --sets the value for 6.4 us high because the timer is completed
                    count <= "1010000000"; --keeps the count full until the timer is reset
                else
                    wrap <= '0'; --sets the timer low since 6.4 us hasn't been reached
                    count <= count + 1; --incremements the 6.4 us timer until reset or timer is complete
                end if;
            elsif En = '1' then 
                    --if statement used for when the 12.8 us timer is started
                if count2 = "10100000000" then --1280 cycles in 12.8 us at 100 MHz
                    wrap2 <= '1'; --sets the value high becuase the timer is completed
                    count2 <= "10100000000"; --keeps the count full until the timer is reset
                else 
                    wrap2 <= '0'; --sets the value low for timer 2
                    count2 <= count2 + 1; --increments the counter until it has reached 12.8 us or is reset
                end if;              
                
            else
                wrap <= wrap; --if neither enable is high then the timer will stay high if already high and low if already low
                wrap2 <= wrap2;
            end if;
        end if;
        
        end process;
        
        clk_out <= wrap; --set high when 6.4 us timer is finished
        clk_out2 <= wrap2;  --set high when 12.8 us timer is finished                 


end Behavioral;
