library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MainFSM is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           EnFSM : in STD_LOGIC;
           D : in STD_LOGIC;
           S : in STD_LOGIC;
           NULLs : in STD_LOGIC;
           enall : out STD_LOGIC;
           gBit : out std_logic;
           disen : out STD_LOGIC);
end MainFSM;

architecture Behavioral of MainFSM is
    
    type state is (Reset, Enable, GotBit, GotNULL);
    signal y : state;   

begin

    Transistions: process(rst, clk, EnFSM, D, S, NULLs)
    
        begin
            if rst = '1' then
                y <= Reset;
            elsif rising_edge(clk) then
                case y is
                    when Reset =>
                        if EnFSM = '1' then --When the receiver is Enabled 
                            y <= Enable;
                        else 
                            y <= Reset; --Stay in the reset state until Enabled
                        end if;
                    
                    when Enable =>
                        if D = '1' or S = '1' then
                            y <= GotBit; --When first data is received moves to next state
                        else
                            y <= Enable; --waits until the first bit is received
                        end if;
                        
                    when GotBit =>
                        if NULLs = '1' then
                            y <= GotNULL; --When Null is received then go into final state
                        else
                            y <= GotBit; --wait until a null is received
                        end if;
                    when GotNULL =>
                        y <= GotNULL;  --stay in gotNULL state until the receiver is reset
                end case;
            end if;
    end process;
    
    outputs: process(y)
        
        begin
            enall <= '0';
            disen <= '0';
            gBit <= '0';
            case y is 
                when Reset =>
                when Enable =>
                when GotBit =>
                    disen <= '1'; --enables the receiver to look for a disconnection error
                    gBit <= '1'; --signal sent to the Space Wire FSM
                when GotNULL =>
                    disen <= '1'; --enables the disconnection error signal
                    enall <= '1'; --used by other components that are used only in the last state
            end case;
    end process;
        
            


end Behavioral;
