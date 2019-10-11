----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2019 01:15:20 PM
-- Design Name: 
-- Module Name: reg8 - Behavioral
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


entity reg8 is 
 port (clock, resetn, en: in std_logic;
        di: in std_logic_vector(7 downto 0);
        q: out std_logic_vector (7 downto 0));
  end reg8;
  
  architecture behavior of reg8 is
   begin 
    process (resetn, clock)
     begin
        if resetn = '1' then
            q<=(others=> '0');
        elsif (clock'event and clock='1') then
            if en='1' then
                q<=di;
          end if;
           end if;      
          end process;
        end behavior;   