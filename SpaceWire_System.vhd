----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2019 12:33:18 PM
-- Design Name: 
-- Module Name: SpaceWire_System - Behavioral
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

entity SpaceWire_System is
 Port (mclk: in std_logic;
        btn: in std_logic_vector(1 downto 0);
        linkstart: in std_logic;
        --Din: in std_logic;
        --Sin: in std_logic;
        --Dout: out std_logic;
        --Sout: out std_logic;
        linkdisable: in std_logic;
        autostart: in std_logic;
        dataReady: out std_logic;
        an: out std_logic_vector(3 downto 0);
        dp: out std_logic;
        a_to_g: out std_logic_vector(6 downto 0);
        sw: in std_logic_vector(15 downto 0));
end SpaceWire_System;

architecture Behavioral of SpaceWire_System is

component hostTop is 

  Port (mclk: in std_logic;
        btn: in std_logic_vector(1 downto 0);
        tickIn: out std_logic;
        TX_Ready: in std_logic;
        TX_Write: out std_logic;  
        TX_Data: out std_logic_vector(7 downto 0);
        TX_Time: out std_logic_vector(7 downto 0);
        RX_Data: in std_logic_vector(7 downto 0);
        RX_Ready: out std_logic;
        RX_Write: in std_logic;
        tickOut: in std_logic;
        endPacket: in std_logic;
        dataReady: out std_logic;
        RX_Time: in std_logic_vector(7 downto 0);
        an: out std_logic_vector(3 downto 0);
        dp: out std_logic;
        a_to_g: out std_logic_vector(6 downto 0);
        sw: in std_logic_vector(15 downto 0));
end component;

signal TX_Ready, RX_Ready, RX_Write, TX_Write, tickIn, tickOut: std_logic;
signal TX_Time, TX_Data,RX_Time, RX_Data: std_logic_vector(7 downto 0);
signal endPacket: std_logic;

component SpaceWire_Top is 
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
        RxData: out std_logic_vector(7 downto 0);
        buff_write: out std_logic;
        control_flag: out std_logic_vector(1 downto 0);
        tick_out : out std_logic;
        time_out: out std_logic_vector(5 downto 0);
        rx_clk: out std_logic
        
        );
end component;   

component clkdiv is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           halfclk : out STD_LOGIC);
end component;     

signal clr: std_logic;
signal thclock : std_logic;
begin
clr<=btn(1);
endPacket <= '0';
node: SpaceWire_Top port map (clock=>mclk, thclock => thclock, tick_In=>tickIn, timeIn=>TX_Time, dataIn=>TX_Data, newData=>TX_Write,
     TX_Ready=>TX_Ready, reset=>clr, link_start=>linkstart, link_disable=>linkdisable, autostart=>autostart,
     buffer_ready=>RX_Ready, buff_write=>RX_Write,RXData=>RX_Data, control_flag=>RX_Time(7 downto 6), time_Out=>RX_Time(5 downto 0),
     tick_Out=>tickOut);
     
host: hostTop port map (mclk=>thclock, btn=>btn, tickIn=>tickIn, TX_Ready=>TX_Ready, TX_Write=>TX_Write, TX_Data=>TX_Data, 
    TX_Time=>TX_Time, RX_Data=>RX_Data, RX_Ready=>RX_Ready, RX_Time=>RX_Time, RX_Write=>RX_Write, tickOut=>tickOut,
    endPacket=>endPacket, dataReady=>dataReady, an=>an, dp=>dp, a_to_g=>a_to_g, sw=>sw); 

div: clkdiv port map(mclk => mclk, clr => clr, halfclk => thclock);
end Behavioral;
