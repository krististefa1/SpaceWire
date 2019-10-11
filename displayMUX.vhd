----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2019 12:01:05 AM
-- Design Name: 
-- Module Name: displayMUX - Behavioral
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

entity displayMUX is
    Port ( a : in STD_LOGIC_VECTOR (63 downto 0);
           b : in STD_LOGIC_VECTOR (63 downto 0);
           c : in STD_LOGIC_VECTOR (63 downto 0);
           d : in STD_LOGIC_VECTOR (63 downto 0);
           e : in STD_LOGIC_VECTOR (63 downto 0);
           f : in STD_LOGIC_VECTOR (63 downto 0);
           g : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC_VECTOR (5 downto 0);
           word : out STD_LOGIC_VECTOR (7 downto 0));
end displayMUX;

architecture Behavioral of displayMUX is

begin

process (sel, a, b, c, d, e, f, g)
begin
    case sel is
        when "000000"=> word <= a(63 downto 56);
        when "000001"=> word <= a(55 downto 48);
        when "000010"=> word <= a(47 downto 40);
        when "000011"=> word <= a(39 downto 32);
        when "000100"=> word <= a(31 downto 24);
        when "000101"=> word <= a(23 downto 16);
        when "000110"=> word <= a(15 downto 8);
        when "000111"=> word <= a(7 downto 0);
        
        when "001000"=> word <= b(63 downto 56);
        when "001001"=> word <= b(55 downto 48);
        when "001010"=> word <= b(47 downto 40);
        when "001011"=> word <= b(39 downto 32);
        when "001100"=> word <= b(31 downto 24);
        when "001101"=> word <= b(23 downto 16);
        when "001110"=> word <= b(15 downto 8);
        when "001111"=> word <= b(7 downto 0);
        
        when "010000"=> word <= c(63 downto 56);
        when "010001"=> word <= c(55 downto 48);
        when "010010"=> word <= c(47 downto 40);
        when "010011"=> word <= c(39 downto 32);
        when "010100"=> word <= c(31 downto 24);
        when "010101"=> word <= c(23 downto 16);
        when "010110"=> word <= c(15 downto 8);
        when "010111"=> word <= c(7 downto 0);
        
        when "011000"=> word <= d(63 downto 56);
        when "011001"=> word <= d(55 downto 48);
        when "011010"=> word <= d(47 downto 40);
        when "011011"=> word <= d(39 downto 32);
        when "011100"=> word <= d(31 downto 24);
        when "011101"=> word <= d(23 downto 16);
        when "011110"=> word <= d(15 downto 8);
        when "011111"=> word <= d(7 downto 0);
        
        when "100000"=> word <= e(63 downto 56);
        when "100001"=> word <= e(55 downto 48);
        when "100010"=> word <= e(47 downto 40);
        when "100011"=> word <= e(39 downto 32);
        when "100100"=> word <= e(31 downto 24);
        when "100101"=> word <= e(23 downto 16);
        when "100110"=> word <= e(15 downto 8);
        when "100111"=> word <= e(7 downto 0);
        
        when "101000"=> word <= f(63 downto 56);
        when "101001"=> word <= f(55 downto 48);
        when "101010"=> word <= f(47 downto 40);
        when "101011"=> word <= f(39 downto 32);
        when "101100"=> word <= f(31 downto 24);
        when "101101"=> word <= f(23 downto 16);
        when "101110"=> word <= f(15 downto 8);
        when "101111"=> word <= f(7 downto 0);
        
        when "110000"=> word <= g(63 downto 56);
        when "110001"=> word <= g(55 downto 48);
        when "110010"=> word <= g(47 downto 40);
        when "110011"=> word <= g(39 downto 32);
        when "110100"=> word <= g(31 downto 24);
        when "110101"=> word <= g(23 downto 16);
        when "110110"=> word <= g(15 downto 8);
        when "110111"=> word <= g(7 downto 0);
        
        when others =>  word <=x"00";
        end case;
end process;

end Behavioral;
