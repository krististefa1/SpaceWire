library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity FSM is
    Port ( D : in STD_LOGIC;
           control : in std_logic;
           S : in STD_LOGIC;
           clk : in std_logic;
           enall : in std_logic;
           reset : in std_logic;
           parity : in STD_LOGIC;
           parity2 : in std_logic;
           encount : out std_logic;
           countdone : in std_logic;
           enreg : out STD_LOGIC;
           RxErr : out std_logic;
           getData1 : out STD_LOGIC;
           getData2 : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is

    type state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
    signal y : state;

begin

    Transitions: process (D, S, parity, parity2, countdone, reset, control, clk, y, enall)
    
        begin
            
            if reset = '1' then
                y <= S0;
                
            elsif rising_edge(clk) then
            
                case y is
                    
                    when S0 =>
                        if D = '1' then --if D or S goes high then data has been recieved 
                            y <= S1;   --and the FSM moves to the next state
                        elsif S = '1' then
                            y <= S1;
                        else --keeps it in the state when no data has been recieved
                            y <= S0;
                        end if;
                        
                    when S1 =>
                        y <= S2; --loads the parity bit once data is recieved 
                        
                                            
                    when S2 =>
                        if control = '1' then  --checks if the second bit loaded is a 0 or 1 
                            y <= S3;    --switches states to load the desired amount of bits
                        elsif control = '0' then
                            y <= S7;
                        end if;
                    
                    when S3 =>
                        y <= S4; --the first control character bit is loaded
                    
                    when S4 =>
                        y <= S5; --the second control Character bit is loaded
                    
                    when S5 =>
                        y <= S6; --loads the parity bit after a control character has been recived
                        
                    when S6 =>
                        if enall = '1' then --if parity check is enabled
                            if parity = '1' then --if the parity for the 4 bits is even then a parity error has happended
                                y <= S11;
                            elsif control = '1' then
                                y <= S3;
                            elsif control = '0' then
                                y <= S7;
                            end if;
                        elsif control = '1' then --if the control bit is one then it goes on to load another 8 bits
                            y <= S3;
                        elsif control = '0' then --if the control bit is 0 then it will go on to load another 2 bits
                            y <= S7;
                        end if;
                        
                    when S7 =>
                        if countdone = '1' then --once the counter is done then all 8bits have been loaded and moves on
                            y <= S8;
                        elsif countdone = '0' then --keeps incrementing until all 8 bits are loaded
                            y <= S7;
                        end if;
                            
                    when S8 => --loads one more bit for a data character
                        y <= S9;
                        
                    when S9 => --loads the parity bit
                        y <= S10;
                    
                    when S10 => --loads the control character
                        if enall = '1' then --if parity check is enabled
                            if parity2 = '1' then --if the parity is even then moves to the parity error state
                                y <= S11;
                            elsif control = '1' then --if the control bit is 1 then control character is loaded
                                y <= S3;
                            elsif control = '0' then --if control bit is 0 then data bits are loaded
                                y <= S7;
                            end if;
                        elsif control = '1' then --if the control bit is 1 then control character is loaded
                            y <= S3;
                        elsif control = '0' then --if control bit is 0 then data bits are loaded
                            y <= S7;
                        end if;

                        
                    when S11 => --sits in parity error until reset by the FSM of the space wire link
                        y <= S11;
                                             
                    end case;
                end if;
            end process;
            
            outputs: process(y)
            begin
                
                case y is
                
                    when S0 =>
                        enreg <= '0';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S1 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';

                    when S2 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S3 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                            
                    when S4 =>
                        enreg <= '1';
                        encount <= '0';                               
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                                
                    when S5 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S6 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '1';
                        RxErr <= '0';
                            
                    when S7 =>
                        enreg <= '1';
                        encount <= '1';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S8 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                            
                    when S9 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S10 =>
                        enreg <= '1';
                        encount <= '0';
                        getData1 <= '1';
                        getData2 <= '0';
                        RxErr <= '0';
                        
                    when S11 =>
                        enreg <= '0';
                        encount <= '0';
                        getData1 <= '0';
                        getData2 <= '0'; 
                        RxErr <= '1';
                end case;
            end process;                          

end Behavioral;
