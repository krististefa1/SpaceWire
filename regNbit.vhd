----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2018 07:54:29 PM
-- Design Name: 
-- Module Name: regNbit - Behavioral
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

entity regNbit is
    generic (n:integer :=4);
  Port (load: in std_logic;
        clk: in std_logic;
        clr: in std_logic;
        d: in std_logic_vector(N-1 downto 0);
        q: out std_logic_vector(N-1 downto 0));
end regNbit;

architecture Behavioral of regNbit is

begin
    process(clk,clr)
        begin 
            if clr='1' then
                q<=(others=>'0');
            elsif clk'event and clk = '1' then
                if load='1' then
                q<=d;
                end if;
   
                end if;
         end process;

end Behavioral;
