library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top is
        port ( clock : in STD_LOGIC;
               reset : in STD_LOGIC;
               linkstart : in std_logic;
               linkdisable : in std_logic;
               gotFCT : in std_logic;
               gotTimeCodes : in std_logic;
               gotNChar : in std_logic;
               gotNULL : in std_logic;
               gotBit : in std_logic;
               CreditError : in std_logic;
               Rx_Err : in std_logic;
               AutoStart : in std_logic;
               
               SendNULL : out STD_LOGIC;
               SendFCT : out STD_LOGIC;
               SendNChars : out std_logic;
               SendTimeCodes : out std_logic;
               EnableT : out std_logic;
               ResetT : out std_logic;
               EnableR : out std_logic;
               ResetR : out std_logic);
end Top;

architecture Behavioral of Top is

    component FSMwhole
        port ( clock : in STD_LOGIC;
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
               ResetTick : out std_logic;
               EnableR : out std_logic;
               ResetR : out std_logic);
     end component;
 
     component Timer
          port ( clk : in STD_LOGIC;
                 E : in STD_LOGIC;
                 En : in STD_LOGIC;
                 clk_out : out STD_LOGIC;
                 clk_out2 : out STD_LOGIC;
                 resetn : in STD_LOGIC);
      end component;
     
      component TickTPulse is
          Port ( gotNULLin : in STD_LOGIC;
                 clock : in STD_LOGIC;
                 reset : in STD_LOGIC;
                 gotNULLout : out STD_LOGIC);
      end component;
      
      signal t1 : std_logic; --timer1 signal
      signal t2 : std_logic; --timer2 signal
      signal e1 : std_logic; --enable timer 1 signal
      signal e2 : std_logic; --enable timer 2 signal
      signal r: std_logic; --reset timer signal
      signal link: std_logic; 
      signal link2: std_logic;
      signal link3: std_logic;    
      signal gotNULL1: std_logic;  
      signal reset1: std_logic;
     
begin
    
    link <= AutoStart and gotNULL; --(AutoStart and gotNULL)
    link2 <= linkstart or link; --linkstart or (AutoStart and gotNULL)
    link3 <= (not linkdisable) and link2; --((not linkdisable) and (linkstart or (AutoStart and gotNULL)))
    f0: FSMwhole port map (clock => clock, reset => reset, LinkEnable => link3, timer1 => t1, timer2 => t2, linkdisable => linkdisable,
    linkstart => linkstart, gotFCT => gotFCT, gotTimeCodes => gotTimeCodes, gotNChar => gotNChar, gotNULL => gotNULL,
    gotBit => gotBit, CreditError => CreditError, Rx_Err => Rx_Err, entimer1 => e1,
    entimer2 => e2, resettimer => r, sendFCT => sendFCT, sendNULL => sendNULL, sendNChars => sendNChars, 
    sendTimeCodes => sendTimeCodes, EnableT => EnableT, EnableR => EnableR, ResetT => ResetT, ResetR => ResetR, ResetTick => reset1);
    
    f1: timer port map (clk => clock, E => e1, En => e2, clk_out => t1, clk_out2 => t2, resetn => r);
    
    f2: TickTPulse port map (clock => clock, reset => reset1, gotNULLin => gotNULL, gotNULLout => gotNULL1);

end Behavioral;
