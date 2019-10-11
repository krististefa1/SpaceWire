----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2019 01:00:45 PM
-- Design Name: 
-- Module Name: tickCounter - Behavioral
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

entity tickCounter is
    Port ( clock : in STD_LOGIC;
           tickIn: out std_logic;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (7 downto 0));
end tickCounter;

architecture Behavioral of tickCounter is
signal temp: std_logic_vector(7 downto 0); 
begin
process(Clock,Reset)
   begin
      if Reset='1' then
         temp <= "00000000";
      elsif(rising_edge(Clock)) then
               temp <= temp + 1;         
      end if;
   end process;
   count <= temp;
    tickIn<=temp(0) and temp(1) and temp(2) and temp(3) and temp(5);
end Behavioral;
