----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/06/2018 01:26:01 PM
-- Design Name: 
-- Module Name: storage_top - Behavioral
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

entity storage_top is
    Port ( clock : in STD_LOGIC;
           resetn : in STD_LOGIC;
           newData: in std_logic;
           en : in STD_LOGIC;
           mode: in std_logic;
		   data: in std_logic_vector(7 downto 0);
           dchar : out STD_LOGIC_VECTOR (7 downto 0));
end storage_top;

architecture Behavioral of storage_top is

signal dataChunks: std_logic_vector(63 downto 0);
signal shift: std_logic;
begin
process(en,clock,resetn,newData,mode)
begin

shift<= '1';

if resetn='1' then
dchar<=x"00";
datachunks<=(others=>'0');

elsif rising_edge(clock) and shift='1' then
if en='1' then
dataChunks(7 downto 0)<=data;
dataChunks(15 downto 8)<=dataChunks(7 downto 0);
dataChunks(23 downto 16)<=dataChunks(15 downto 8);
dataChunks(31 downto 24)<=dataChunks(23 downto 16);
dataChunks(39 downto 32)<=dataChunks(31 downto 24);
dataChunks(47 downto 40)<=dataChunks(39 downto 32);
dataChunks(55 downto 48)<=dataChunks(47 downto 40);
dataChunks(63 downto 56)<=dataChunks(55 downto 48);
dchar<=dataChunks(63 downto 56);
end if;
end if;
end process;


end Behavioral;
