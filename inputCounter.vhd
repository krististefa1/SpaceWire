----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2018 10:02:57 AM
-- Design Name: 
-- Module Name: inputCounter - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inputCounter is
  Port (newData: in std_logic;
        resetn: in std_logic;
        clock: in std_logic;
        fctReady: out std_logic;
        blockSel: out std_logic_vector(2 downto 0)
        );
end inputCounter;

architecture Behavioral of inputCounter is
signal wordCount: std_logic_vector(5 downto 0);
signal initial: std_logic;
begin

process(resetn, clock, newData)
begin
if resetn = '1' then
wordCount<="000000";
initial<='1';
elsif rising_edge(clock) and newData='1' then
    if initial ='1' then
        wordCount<=wordCount;
        initial<='0';
    else
        wordCount<=wordCount+1;
    if wordCount > 8 then
        fctReady<='1';
    else 
        fctReady<='0';     
        end if;         
    end if;
end if;
end process;
blockSel<=wordCount(5 downto 3);
end Behavioral;
