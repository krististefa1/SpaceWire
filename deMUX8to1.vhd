----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2018 12:52:12 PM
-- Design Name: 
-- Module Name: mux8to1 - Behavioral
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

entity demux8to1 is
    Port ( a : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0);
           c : out STD_LOGIC_VECTOR (7 downto 0);
           d : out STD_LOGIC_VECTOR (7 downto 0);
           e : out STD_LOGIC_VECTOR (7 downto 0);
           f : out STD_LOGIC_VECTOR (7 downto 0);
           i : out STD_LOGIC_VECTOR (7 downto 0);
           j : out std_logic_vector (7 downto 0);
           --regEn: out std_logic_vector(7 downto 0);
           wr_rd : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (2 downto 0);
           h : in STD_LOGIC_VECTOR (7 downto 0));
end demux8to1;

architecture Behavioral of demux8to1 is
signal sel: std_logic_vector(3 downto 0);
begin
sel(3)<=not(wr_rd);
sel(2)<=address(2);
sel(1)<=address(1);
sel(0)<=address(0);

a <= h when sel = "1000" else "00000000";
b <= h when sel = "1001" else "00000000";
c <= h when sel = "1010" else "00000000";
d <= h when sel = "1011" else "00000000";
e <= h when sel = "1100" else "00000000";
f <= h when sel = "1101" else "00000000";
i <= h when sel = "1110" else "00000000";
j <= h when sel = "1111" else "00000000";



end Behavioral;
