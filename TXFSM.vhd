----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2019 01:21:36 PM
-- Design Name: 
-- Module Name: TXFSM - Behavioral
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

entity TXFSM is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           TX_Ready : in STD_LOGIC;
           TX_Write : out STD_LOGIC);
end TXFSM;

architecture Behavioral of TXFSM is
type state is (S1,S2,S3);
signal S: state;
begin
States: process (clock,reset, TX_Ready)
    begin
        if reset = '1' then S<=S1; TX_Write<='0';
        
        elsif (rising_edge(clock) and TX_Ready='1') then
            case S is 
                When S1=> 
                    S<=S2;
                When S2=>
                    TX_Write<='1';
                    S<=S3;
                When S3=>
                    TX_Write<='0';
                    S<=S2;
                end case;    
          end if;
      end process;                  
end Behavioral;
