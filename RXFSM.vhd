----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2019 12:44:29 AM
-- Design Name: 
-- Module Name: RXFSM - Behavioral
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

entity RXFSM is
 Port (clock: in std_logic;
       reset: in std_logic;
       RX_Write: in std_logic;
       RX_Ready: out std_logic;
       endPacket: in std_logic;
       dataReady: out std_logic;
       storEn: out std_logic_vector(6 downto 0));
end RXFSM;

architecture Behavioral of RXFSM is
type state is (S1,S2,S3,S4,S5,S6,S7,S8);
signal S: state;
signal count: std_logic_vector(5 downto 0);
begin
States: process(clock, reset, RX_Write)
    begin
    if reset = '1' then S<=S8; count<="000000";
            RX_Ready <= '0';
    elsif (rising_edge(clock)) then
        case S is
            when S1=> 
                
                S<=S8;
                count<=count+1;
                storEn<="1000000";
            when S2=> 
                S<=S8;
                count<=count+1;
                storEn<="0100000";
            when S3=> 
                S<=S8;
                count<=count+1;
                storEn<="0010000";
            when S4=> 
                S<=S8;
                count<=count+1;
                storEn<="0001000";
            when S5=> 
                S<=S8;
                count<=count+1;
                storEn<="0001000";
            when S6=> 
                S<=S8;
                count<=count+1;
                storEn<="0000010";
            when S7=> 
                S<=S8;
                count<=count+1;
                storEn<="0000001";
                
            when S8=>
            RX_Ready <= '1';
                if count > "000000" and endPacket = '0' then dataReady<='1'; end if;
                if RX_Write = '1' then
                    case count(5 downto 3) is
                        when "000"=>S<=S1;  
                        when "001"=>S<=S2;
                        when "010"=>S<=S3;
                        when "011"=>S<=S4;
                        when "100"=>S<=S5;
                        when "101"=>S<=S6;
                        when "110"=>S<=S7;
                        when others=>S<=S1;
                    end case;
                end if;
        end case;
     end if;                     
    end process;

end Behavioral;
