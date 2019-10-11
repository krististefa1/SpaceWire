library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ClkFSM is
    Port ( mclk : in STD_LOGIC;
           Rclk : in STD_LOGIC;
           reset : in std_logic;
           clk : out STD_LOGIC);
end ClkFSM;

architecture Behavioral of ClkFSM is
    
    type state is (zero, rising, one, falling);
    signal y : state;
    
begin

    Transistions: process(mclk, Rclk, reset)
        
        begin
            if reset = '1' then
                y <= zero;
            elsif rising_edge(mclk) then
                case y is
                    --when wat=>
                        --y<=zero;
                    when zero =>
                        if Rclk = '1' then
                            y <= rising;
                        else
                            y <= zero;
                        end if;
                    
                    when rising =>
                        y <= one;
                    
                    when one =>
                        if Rclk = '1' then
                            y <= one;
                        else    
                            y <= falling;
                        end if;
                    
                    when falling =>
                        y <= zero;
                end case;
            end if;
    end process;
    
    outputs: process(y)
        begin
            clk <= '0';
            case y is
                when zero =>                    
                when rising =>
                    clk <= '1';
                when one =>
                when falling =>
                    clk <= '1';
            end case;
     end process;
end Behavioral;
