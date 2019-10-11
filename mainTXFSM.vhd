----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2018 12:25:53 PM
-- Design Name: 
-- Module Name: TopSeqFSM - Behavioral
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

entity mainTXFSM is
    Port ( resetn : in STD_LOGIC;
           clock : in STD_LOGIC;
           state: in STD_LOGIC_VECTOR(1 downto 0);
		   tickIn: in STD_LOGIC; --signal from host when sending time-code
		   enOut: out STD_LOGIC; --enable for 10 to 1 block
		   enIn: out std_logic; --enable for the input deMUX block (negative logic) 
           sel : out STD_LOGIC_vector(1 downto 0); --select for code char MUX
		   request: out STD_LOGIC_VECTOR(2 downto 0)); --requests for certain codes
end mainTXFSM;

architecture Behavioral of mainTXFSM is 
type stage is (S1, S2, S3, S4, S5);
signal S: stage;
signal selector: std_logic_vector(1 downto 0);

begin 
Transitions: process (clock, resetn)
	begin 
		if resetn = '1' then S<=S1;
		
		 elsif (rising_edge(clock)) then
			Case S is	
				when S1 =>
					if state="01" then S<=S2;  
					else S<=S1; end if;
				when S2 =>
					if state="10" then S<=S3; 
					elsif state = "00" then S<=S1;
                    else S<=S2; end if;
				when S3 => 
					if state="11"  then S<=S4;
					elsif state = "00" then S<=S1; 	
                    else S<=S3; end if;
                when S4 =>
                    if state="00"  then S<=S1;
					elsif tickIn='1' then S<=S5;
                    else S<=S4; end if;
                when S5 =>
                    if tickIn='0'  then S<=S4; 
					elsif state="00" then S<=S1;
                    else S<=S5; end if;
                
			end case;
		end if;
	end process;
Outputs: process (S)
	begin	
	enIn<='0'; enOut<='0'; selector<="00";request<="000";
		Case S is 
			when S1=>  --send/read nothing
				selector<="10";
				enIn<='1';
				enOut<='0'; 
				request<="000";
			when S2 => --read nothing/send NULLs
				selector<="10";
				enIn<='1';
				enOut<='1';
				request<="101";
			when S3 =>  --read no data/count FCTs/send NULLS
				selector<="10";
				enIn<='1';
				enOut<='1';
				request<="001"; 
			when S4 => --Allow full function
                selector<="01";
				enIn<='0';
				enOut<='1';
				request<="101";
            when S5 =>  --Send a Time-Code quickly 
                selector<="00";
				enIn<='0';
				enOut<='1';
				request<="100";
		end case;
	end process;
	   sel<=selector;
end Behavioral;

