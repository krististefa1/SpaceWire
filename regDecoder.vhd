----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2018 11:47:36 AM
-- Design Name: 
-- Module Name: regDecoder - Behavioral
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

entity regDecoder is
    Port ( inSel : in STD_LOGIC_VECTOR (2 downto 0);
           mode: in std_logic;
           regEn : out STD_LOGIC_VECTOR (7 downto 0);
           outSel : in STD_LOGIC_VECTOR (2 downto 0));
end regDecoder;

architecture Behavioral of regDecoder is
signal message: std_logic_vector(2 downto 0);
begin
message <= insel when mode = '0' else outsel;

with message select 
regEn <=  x"01" when "000",
        x"02" when "001",
        x"04" when "010",
        x"08" when "011",
        x"10" when "100",
        x"20" when "101",
        x"40" when "110",
        x"80" when "111",
        "00000000" when others;

end Behavioral;
