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

entity mux8to1 is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           c : in STD_LOGIC_VECTOR (7 downto 0);
           d : in STD_LOGIC_VECTOR (7 downto 0);
           e : in STD_LOGIC_VECTOR (7 downto 0);
           f : in STD_LOGIC_VECTOR (7 downto 0);
           i : in STD_LOGIC_VECTOR (7 downto 0);
           j : in std_logic_vector (7 downto 0);
           --wr_rd : in STD_LOGIC;
           --regEn: out std_logic_vector(7 downto 0);
           address : in STD_LOGIC_VECTOR (2 downto 0);
           h : out STD_LOGIC_VECTOR (7 downto 0));
end mux8to1;

architecture Behavioral of mux8to1 is
signal sel: std_logic_vector(2 downto 0);
begin

sel(2)<=address(2);
sel(1)<=address(1);
sel(0)<=address(0);

with sel select
h<=     a when "000",
        b when "001",
        c when "010",
        d when "011",
        e when "100",
        f when "101",
        i when "110",
        j when "111",
        "00000000" when others;       
end Behavioral;
