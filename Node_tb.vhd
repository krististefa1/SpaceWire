----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2019 12:04:11 PM
-- Design Name: 
-- Module Name: Node_tb - Behavioral
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

entity Node_tb is
--  Port ( );
end Node_tb;

architecture Behavioral of Node_tb is

component SpaceWire_System is 
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
end component;

signal mclk: std_logic;
signal btn: std_logic_vector(1 downto 0);
signal linkstart: std_logic;
signal linkdisable: std_logic;
signal autostart: std_logic;
signal dataReady: std_logic;
signal an: std_logic_vector(3 downto 0);
signal dp: std_logic;
signal a_to_g: std_logic_vector(6 downto 0);
signal sw: std_logic_vector(15 downto 0);
begin

uut: SpaceWire_System port map (mclk=>mclk, btn=>btn, linkstart=>linkstart, linkdisable=>linkdisable,
                                        autostart=>autostart, dataReady=>dataReady, an=>an, dp=>dp, 
                                        a_to_g=>a_to_g, sw=>sw);
stimulate_clock: process
     begin
     mclk <= '0'; 
     wait for 5 ns; 
     mclk <= '1'; 
     wait for 5 ns; 
     end process; 

stim: process
begin
btn<="10";
wait for 20ns;
btn<="00";
sw<=x"0000";
linkstart<='0';
linkdisable<='0';
autostart<='0';
wait for 6.4 us;
wait for 12.8 us;
linkstart<='1';
linkdisable<='0';
wait for 13 us;


wait for 6.4 us;
wait for 12.8 us;
sw<=x"F100";
btn<="01";
wait for 20ns;
btn<="00";
wait for 100ns;
sw<=x"9800";
btn<="01";
wait;
end process;
                                             
end Behavioral;
