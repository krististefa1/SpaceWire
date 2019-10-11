----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2018 11:32:19 AM
-- Design Name: 
-- Module Name: SpaceWire_Top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SpaceWire_Top is
 Port (clock: in std_logic;
        thclock : in std_logic;
        tick_in: in std_logic;
        timeIn: in std_logic_vector(7 downto 0);
        dataIn: in std_logic_vector(7 downto 0);
        newData: in std_logic; 
        TX_Ready: out std_logic;
        Reset : in std_logic;
        link_start: in std_logic;
        link_disable: in std_logic;
        autostart: in std_logic;
        buffer_ready: in std_logic;
        --Dout: out std_logic;
        --Sout: out std_logic;
        --Din: in std_logic;
        --Sin: in std_logic;
        RxData: out std_logic_vector(7 downto 0);
        buff_write: out std_logic;
        control_flag: out std_logic_vector(1 downto 0);
        tick_out : out std_logic;
        time_out: out std_logic_vector(5 downto 0);
        rx_clk: out std_logic
        
        );
end SpaceWire_Top;


architecture Behavioral of SpaceWire_Top is

component Receiver is 
     Port ( mclk : in STD_LOGIC;
          reset : in STD_LOGIC;
          D : in STD_LOGIC;
          S : in STD_LOGIC;
          Enable : in STD_LOGIC;
          gotFCT : out STD_LOGIC;
          gotNChar : out STD_LOGIC;
          gotTime_Code : out STD_LOGIC;
          gotNULL : out STD_LOGIC;
          gotBit : out STD_LOGIC;
          CreditErr : out STD_LOGIC;
          RxError : out STD_LOGIC;
          Control_flags_out : out STD_LOGIC_VECTOR (1 downto 0);
          Time_out : out STD_LOGIC_VECTOR (5 downto 0);
          Tick_out : out STD_LOGIC;
          RecClk : out STD_LOGIC;
          BufferReady : in STD_LOGIC;
          RxData : out STD_LOGIC_VECTOR (7 downto 0);
          BufferWrite : out STD_LOGIC);
 end component;         

component Top is 
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
    end component;
    
component TX_top is
     Port (sysTime_In: in std_logic_vector(7 downto 0);
           tickIn: in std_logic;
           data_In: in std_logic_vector(7 downto 0);
           newData: in std_logic;
           clock: in std_logic;
           state: in std_logic_vector(1 downto 0);
           reset: in std_logic;
           gotFCT: in std_logic;
           RX_Ready: in std_logic;
           d: out std_logic;
           s: out std_logic
            );
    end component;   
     
    signal D: std_logic;
    signal S: std_logic;
    signal gotFCT,gotNchar,gotTime_code, gotNULL, gotBit, CreditErr, Rx_err, EnRx, RstRx: std_logic;
    signal RstTx, EnTx, SendNull, SendFct, SendNChar, SendTime_code: std_logic;
    signal dataReady, RX_ready: std_logic;
    signal state: std_logic_vector(4 downto 0);
    signal tx_state: std_logic_vector(1 downto 0);
begin

   state<=enTx & sendNull & sendFCT& sendnChar & sendTime_code;
decode: process(sendNull, enTx, sendFCT, sendnchar,sendtime_code, state)
    begin
    case state is
         when "10000" =>
            tx_state<="00";
         when "11000" =>
            tx_state<="01";
         when "11100" =>
            tx_state<="10";
         when "11111" =>
            tx_state<="11";
         when others =>
            tx_state<="00"; 
         end case;
    end process;
dataReady <= newData;


f0: TX_top port map (clock=>thclock, sysTime_In=>timeIn, tickIn=>tick_In, data_In=>dataIn, newData=>dataReady, state=>tx_state, reset=>RstTx,
                        gotFCT=>gotFCT, RX_Ready=>RX_Ready, d=>d, s=>s);
f1: top port map(clock => clock, reset => Reset, linkstart => link_start, linkdisable => link_disable, gotFCT => gotFCT, gotTimeCodes => gotTime_code,
    gotNChar => gotNChar, gotNULL => gotNULL, gotBit => gotBit, CreditError => CreditErr, Rx_Err => Rx_err,
    AutoStart => autostart, SendNULL => SendNULL, SendFCT => SendFCT, SendNChars => SendNChar, SendTimeCodes => SendTime_code,
    EnableT => EnTx, ResetT => RstTx, EnableR => EnRX, ResetR => RstRx);
    
Rec: Receiver port map(mclk => clock, reset => RstRx, D => D, S => S, Enable => EnRx, gotFCT => gotFCT, gotNChar => gotNChar,
    gotTime_code => gotTime_code, gotNULL => gotNULL, gotBit => gotBit, CreditErr => CreditErr, RxError => Rx_err,
    Control_flags_out => Control_flag, Time_out => Time_out, Tick_out => Tick_out, RecClk => Rx_clk, BufferReady => buffer_Ready,    
    RxData => RxData, BufferWrite => Buff_write);
 TX_Ready<=tx_state(1) and tx_state(0);   
 
end Behavioral;
