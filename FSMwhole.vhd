library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSMwhole is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           timer1 : in std_logic;
           timer2 : in std_logic;
           linkstart : in std_logic;
           linkdisable : in std_logic;
           gotFCT : in std_logic;
           gotTimeCodes : in std_logic;
           gotNChar : in std_logic;
           gotNULL : in std_logic;
           gotBit : in std_logic;
           CreditError : in std_logic;
           Rx_Err : in std_logic;
           LinkEnable : in std_logic;
           
           entimer1 : out STD_LOGIC;
           entimer2 : out STD_LOGIC;
           resettimer : out STD_LOGIC;
           SendNULL : out STD_LOGIC;
           SendFCT : out STD_LOGIC;
           SendNChars : out std_logic;
           SendTimeCodes : out std_logic;
           EnableT : out std_logic;
           ResetT : out std_logic;
           ResetTick: out std_logic;
           EnableR : out std_logic;
           ResetR : out std_logic);
end FSMwhole;

architecture Behavioral of FSMwhole is

    type state is (S1, S2, S3, S4, S5, S6);
    signal y : state;
    
begin

    Trasitions: process (reset, clock, timer1, timer2, linkdisable, gotFCT, gotTimeCodes,
                        gotNChar, gotNULL, CreditError, Rx_Err, LinkEnable)
                  
        begin
    
            
            if reset = '1' then
            
                y <= S1;
                resettimer <= '1'; --resets the timer when the FSM is reset
                            
            elsif (clock'event and clock = '1') then
                
                case y is
                    
                    when S1 => --Error Reset state
                        ResetTick <= '1';
                        if timer1 = '1' then resettimer <= '1'; y <= S2; --resets the timer when it transitions states
                        else resettimer <= '0'; y <= S1; --keeps the timer running while in the 3first state
                        end if;
                    
                    
                    when S2 => --Error Wait state
                    ResetTick <= '0';
                        if (Rx_Err = '1' or gotFCT = '1' or gotTimeCodes = '1' or gotNChar = '1') then y <= S1; --goes to state 1
                        else
                            if timer2 = '1' then resettimer <= '1'; y <= S3; --resets the timer when going to state 3
                            else resettimer <= '0'; y <= S2; --keeps the timer going while in the state
                            end if;
                        end if;
                    
                    
                    when S3 => --Ready state
                        resettimer <= '0'; --allow the timer to be started 
                        if (Rx_Err = '1' or gotFCT = '1' or gotTimeCodes = '1' or gotNChar = '1') then y <= S1; --goes to state 1 when any of the values are set
                        else 
                            if LinkEnable = '1' then y <= S4; -- linkenable <= (not linkdisable) and (linkstart or (AutoStart and gotNULL)
                            else y <= S3; --stays in state 3 until one of the previous conditions are set
                            end if;                           
                        end if;
                    
                    
                    when S4 => --Started state
                        if gotNULL = '0' then 
                            if (Rx_Err = '1' or gotFCT = '1' or gotTimeCodes = '1' or gotNChar = '1') then y <= S1;
                            else
                                if timer2 = '1' then resettimer <= '1';  y <= S1; --times out if no NULLs are recevied in 12.8 us
                                else resettimer <= '0'; y <= S4; --stays in state 4 to keep looking for NULLs
                                end if;
                            end if;
                        else --if gotNULL is 1
                            if (Rx_Err = '1' or gotFCT = '1' or gotTimeCodes = '1' or gotNChar = '1') then y <= S1; --checks these conditions once more time
                            else resettimer <= '1'; y <= S5; --resets the timer and goes to state 5
                            end if;
                        end if;
                    
                    
                    when S5 => --Connecting state
                        resettimer <= '0'; --allows the timer to be enabled
                        if gotFCT = '1' then y <= S6; --goes staight to the Running state if an FCT is recieved
                        else 
                            if (Rx_Err = '1' or gotTimeCodes = '1' or gotNChar = '1') then y <= S1; --goes back to state 1 
                            else 
                                if timer2 = '1' then y <= S1; --goes to state 1 if 12.8 us timer is reached before FCT is recieved
                                else y <= S5; --stayes in state 5 
                                end if;
                            end if;
                        end if;
                    
                    
                    when S6 => --Running state
                        if (Rx_Err = '1' or CreditError = '1' or LinkDisable = '1') then y <= S1;
                        else y <= S6; --stays in the running state until Rx_Err, CreditError or LinkDisable is 1
                        end if;                       
                                  
                 end case;
             else
             end if;
      end process;
      
      Outputs : process (y)
      begin
        
        case y is
            when S1 =>
                
                ResetR <= '1'; --resets receiver
                ResetT <= '1'; --resets transmitter
                EnableR <= '0';
                EnableT <= '0';
                entimer1 <= '1';  --enables the 6.4 us timer
                entimer2 <= '0';
                sendNULL <= '0';
                sendNChars <= '0';
                sendTimeCodes <= '0';
                sendFCT <= '0';
                
            when S2 => 
                               
                ResetR <= '0'; 
                ResetT <= '1'; --resets transmitter
                EnableR <= '1'; --enables receiver
                EnableT <= '0';
                entimer1 <= '0';
                entimer2 <= '1'; --enables the 12.8 us timer
                sendNULL <= '0';
                sendNChars <= '0';
                sendTimeCodes <= '0';
                sendFCT <= '0';
               
            when S3 =>
                
                ResetR <= '0'; 
                ResetT <= '1'; --rests the transmitter
                EnableR <= '1'; --enables the receiver
                EnableT <= '0';
                entimer1 <= '0';
                entimer2 <= '0';
                sendNULL <= '0';
                sendNChars <= '0';
                sendTimeCodes <= '0';
                sendFCT <= '0';
                
            when S4 => 
                
                ResetR <= '0'; 
                ResetT <= '0';
                EnableR <= '1'; --enables the receiver
                EnableT <= '1'; --enables the transmitter
                entimer1 <= '0';
                entimer2 <= '1'; --enables the 12.8 us timer
                sendNULL <= '1'; --FSM allows the transmitter to send NULLs
                sendNChars <= '0';
                sendTimeCodes <= '0';
                sendFCT <= '0';
                
            when S5 =>
               
                ResetR <= '0'; 
                ResetT <= '0';
                EnableR <= '1'; --enable the receiver
                EnableT <= '1'; --enables the transmitter
                entimer1 <= '0';
                entimer2 <= '1'; --starts the 12.8 us timer
                sendNULL <= '1'; --allows the transmitter to send NULLs
                sendNChars <= '0';
                sendTimeCodes <= '0';
                sendFCT <= '1'; --allows the transmitter to send FCTs
           
            when S6 =>
               
                ResetR <= '0'; 
                ResetT <= '0';
                EnableR <= '1'; --enables the receiver
                EnableT <= '1'; --enables the trasmitter
                entimer1 <= '0';
                entimer2 <= '0';
                sendNULL <= '1'; --allows the transmitter to send NULLs
                sendNChars <= '1'; --allows the transmitter to send NChars
                sendTimeCodes <= '1'; --allows the transmitter to send TimeCodes
                sendFCT <= '1'; --allows the transmitter to send FCTs
            
            end case;
        end process;            
end Behavioral;
