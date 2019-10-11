library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSMEncode is
    Port ( Do : in STD_LOGIC;
           D : in STD_LOGIC;
           S : out STD_LOGIC;
           en : in std_logic;
           clk : in std_logic;
           clr : in std_logic);
end FSMEncode;

architecture Behavioral of FSMEncode is

    type state is (Start, S1, S0);
    signal y : state;

begin
    process(clk, clr)
        begin
            if clr = '1' then
                y <= Start;
            elsif rising_edge(clk) then
            if en = '1' then
                case y is
                    when Start =>
                        if D = '1' then
                            y <= S0;
                        elsif D = '0' then
                            y <= S1;
                        end if;
                    
                    when S0 =>
                        if Do = D then
                            y <= S1;
                        end if;
                    
                    when S1 =>
                        if D = Do then
                            y <= S0;
                        end if;
                
                end case;
            end if;
            end if;
    end process;
    
    output: process(y)
        begin
            S <= '0';
            case y is 
            when Start => S <= '0';
            when S0 => S <= '0';
            when S1 => S <= '1';
            end case;
    end process;
end Behavioral;
