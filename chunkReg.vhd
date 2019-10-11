----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2019 11:52:45 PM
-- Design Name: 
-- Module Name: chunkReg - Behavioral
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

entity chunkReg is
    Port ( data : in STD_LOGIC_VECTOR (7 downto 0);
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           contents : out STD_LOGIC_VECTOR (63 downto 0));
end chunkReg;

architecture Behavioral of chunkReg is
signal dataChunks: std_logic_vector(63 downto 0);
--signal shift: std_logic;
begin
process(en,clock,reset)
begin

if reset='1' then
contents<=(others=>'0');
datachunks<=(others=>'0');

elsif rising_edge(clock) then
if en='1' then
dataChunks(7 downto 0)<=data;
dataChunks(15 downto 8)<=dataChunks(7 downto 0);
dataChunks(23 downto 16)<=dataChunks(15 downto 8);
dataChunks(31 downto 24)<=dataChunks(23 downto 16);
dataChunks(39 downto 32)<=dataChunks(31 downto 24);
dataChunks(47 downto 40)<=dataChunks(39 downto 32);
dataChunks(55 downto 48)<=dataChunks(47 downto 40);
dataChunks(63 downto 56)<=dataChunks(55 downto 48);
contents<=dataChunks;
end if;
end if;
end process;


end Behavioral;

