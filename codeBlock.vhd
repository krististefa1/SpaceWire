----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2018 12:25:53 PM
-- Design Name: 
-- Module Name: codeFSM - Behavioral
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
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity codeBlock is
    Port ( resetn : in STD_LOGIC;
           clock : in STD_LOGIC;
		   request: in std_logic_vector(2 downto 0);
           code : out STD_LOGIC_VECTOR (8 downto 0));
end codeBlock;

architecture Behavioral of codeBlock is 


begin 
	process(resetn, request)
		begin
		if resetn = '1' then 
			code<="111010000"; --there's a code "00" so "00000000" can't be used
		else
			case request is 
				when "001" =>      --FCT code
					code<= "100" & "000000";
				when "010" =>	   --EOP code
					code<= "101" & "000000";
				when "011" =>      --EEP code
					code<= "110" & "000000";
				when "100" =>	   --ESC code (never used alone)
					code<= "111" & "000000";
				when "101" =>      --NULL code (ESC + FCT)
					code<= "1110100" & "00";
				when others	=>
					code<= "1110100" & "00";
				end case;
		end if;
	end process;
end Behavioral;
