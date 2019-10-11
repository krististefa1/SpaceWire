library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlFSM is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           enall : in STD_LOGIC;
           cld : in STD_LOGIC;
           dld : in STD_LOGIC;
           Control : in STD_LOGIC_VECTOR (1 downto 0);
           gotFCT : out STD_LOGIC;
           gotNULL : out STD_LOGIC;
           gotTime_Code : out STD_LOGIC;
           gotNChar : out STD_LOGIC;
           E_OP : out std_logic;
           E_EP : out std_logic;
           ESCErr : out std_logic;
           ldNchar : out STD_LOGIC;           
           ldTimeCode : out STD_LOGIC);
end ControlFSM;

                             architecture Behavioral of ControlFSM is

    type state is (Start, FCT, ESC, Err, TimeCode, NULLs, NChar, EOP);
    signal y : state;  

begin
    process(clk, clr, dld, cld, Control, enall)
        begin
            if clr = '1' then
                y <= Start;
            elsif rising_edge(clk) then
                
                case y is
                    
                    when Start =>
                        if cld = '1' then --if a control character was loaded
                            if enall = '1' then --checks if the character can be acted upon
                                if Control = "00" then --FCT is received
                                    y <= FCT;
                                elsif Control = "11" then --ESC is received
                                    y <= ESC;
                                    
                                    
                                ---------------------------------------    
                                elsif Control = "10" then
                                    y <= EOP;
                                elsif Control = "01" then
                                    y <= EOP;
                                -------------------------------------------    
                                
                                
                                end if;
                            elsif Control = "11" then --ESC can be looked for when enall is high to look for a null (ESC - FCT)
                                y <= ESC;
                                
                                
                            -----------------------------------------------------------
                            elsif Control = "10" then
                                y <= EOP; 
                            elsif Control = "01" then
                                y <= EOP;
                            ---------------------------------------------------------------
                            
                            
                            end if;
                        elsif dld = '1' then --if an 8 bit data character was loaded
                            if enall = '1' then --can only be acted upon if the receiver is allowed to 
                                y <= NChar;
                            else
                                y <= Start;
                            end if;
                        else
                            y <= Start;
                        end if;
                        
                    when FCT =>
                        y <= Start; --moves straigt to the beginning state to look for new characters
                    
                    when ESC =>
                        if cld = '1' then --if control character was received
                            if enall = '1' then --only acted upon if enabled by Reveiver FSM
                                if Control = "11" then--("11" or "10" or "01") then --if any of these are received after an ESC then an error has occured
                                    y <= Err;
                                elsif Control = "10" then
                                    y <= Err;
                                elsif Control = "01" then
                                    y <= Err;   
                                
                                elsif Control = "00" then --a FCT after an ESC results in a NULL
                                    y <= NULLs;
                                end if;
                            elsif enall = '0' then --when the receiver has not allowed other characters
                                if control = "00" then --FCT after an ESC the NULL is received
                                    y <= NULLs;
                                elsif control = ("11" or "10" or "01") then --Reciever is only looking for NULLs so these are ignored
                                    y <= Start;
                                end if;
                            end if;
                        elsif dld = '1' then --8 bit character was received after an ESC
                            if enall = '1' then --if the receiver can look for the value
                                y <= TimeCode; --Time code is then received
                            else
                                y <= Start; --if not allowed to receive timecodes yet then go back to start state
                            end if;
                        else
                            y <= ESC; --waits for a control character or 8 data bits
                        end if;
                        
                    when Err =>
                        y <= Err; --Receiver will be reset by FSM because an ESC error happened
                    
                    when NULLs =>
                        y <= Start;  --looks for new values after a Null is received
                        
                    when TimeCode => --looks for new values after TimeCode is received
                        y <= Start;
                        
                    when NChar =>
                        y <= Start; --go back to start state after a character is received
                        
                    when EOP => 
                        y <= Start;
                end case;
            end if;
    end process;
                
    output: process(y)
        begin
        gotFCT <= '0';
        gotNULL <= '0';
        gotTime_Code <= '0';
        gotNChar <= '0';
        ESCErr <= '0';
        ldNchar <= '0';
        ldTimeCode <= '0';
        E_OP <= '0';
        E_EP <= '0';
            case y is

                when Start =>
                when ESC =>
                when FCT =>
                    gotFCT <= '1'; --flaged by FSM and Transmitter
                when Err =>
                    ESCErr <= '1'; --sent to FSM where the system will be reset
                when TimeCode =>
                    gotTime_Code <= '1'; 
                    ldTimeCode <= '1'; --allows the Time-Codes to be written to the host system
                when NULLs =>
                    gotNULL <= '1';
                when NChar =>
                    gotNChar <= '1';
                    ldNChar <= '1'; --allows the NChar to be written to the host system
                when EOP =>
                    gotNChar <= '1';
                    ldNChar <= '1';
                    if Control = "10" then
                        E_EP <= '1';
                    elsif Control = "01" then
                        E_OP <= '1';    
                    end if;                
                    
            end case;
     end process;


end Behavioral;
