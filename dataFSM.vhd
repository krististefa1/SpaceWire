----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2018 11:33:57 AM
-- Design Name: 
-- Module Name: dataFSM - Behavioral
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

entity dataFSM is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           fctReady : in STD_LOGIC;
           RX_Ready: in std_logic;
           mode: out std_logic;
           count : in STD_LOGIC_VECTOR (2 downto 0);
           --regEn : out STD_LOGIC_VECTOR (6 downto 0);
           muxSel : out STD_LOGIC_VECTOR (2 downto 0));
end dataFSM;

architecture Behavioral of dataFSM is
type state is (S1, S2, S3, S4, S5, S6, S7,S8,S9);
signal S: state;
signal Q: integer range 0 to 7; --allows 8-bit contents to be uploaded 
signal cred: std_logic_vector(2 downto 0);
begin 
Transitions: process (clock, reset)
	begin 
		if reset = '1' then S<=S1; Q<=0; 
		
		 elsif (rising_edge(clock)) then
			Case S is	
				when S1 =>
				    if fctReady='1' then S<=S2;
				    else S<=S1; end if;
				when S2 =>
				    if Rx_Ready='1' then S<=S3; cred<=count;
				    else S<=S2; end if;
				when S3 => 	
				    if cred > 0 and Q=6 then S<=S4; cred<=cred-1; Q<=0;
				    else S<=S3; Q<=Q+1; end if;
                when S4 =>
                    if cred > 0 and Q=6 then S<=S5; cred<=cred-1; Q<=0;
                                    else S<=S4; Q<=Q+1; end if;
                when S5 =>
                    if cred > 0 and Q=6 then S<=S6; cred<=cred-1; Q<=0;
                                    else S<=S5; Q<=Q+1; end if;
                when S6 =>
                    if cred > 0 and Q=6 then S<=S7; cred<=cred-1; Q<=0;
                                    else S<=S6; Q<=Q+1; end if; 
                when S7 =>
                    if cred > 0 and Q=6 then S<=S8; cred<=cred-1; Q<=0;
                                    else S<=S7; Q<=Q+1; end if;
                when S8 =>
                    if cred > 0 and Q=6 then S<=S9; cred<=cred-1; Q<=0;
                                    else S<=S8; Q<=Q+1; end if; 
                when S9 =>
                    if cred > 0 and Q=6 then S<=S1; cred<=cred-1; Q<=0;
                                    else S<=S9; Q<=Q+1; end if;                 
			end case;
		end if;
	end process;
Outputs: process (S)
	begin	
		Case S is 
			when S1=>
				muxsel<="000";
				mode<='0';
			when S2 =>
				muxsel<="000";
                mode<='0';
			when S3 => 
				muxsel<="000";
				mode<='1';
			when S4 =>
                muxsel<="001";
                mode<='1';
            when S5 =>
               muxsel<="010";
               mode<='1';
            when S6 => 
                muxsel<="011";
                mode<='1';
            when S7 =>
                muxsel<="100";
                mode<='1';
            when S8 =>
                muxsel<="101";
                mode<='1'; 
            when S9 =>
                muxsel<="110"; 
                mode<='1';      
		end case;
	end process;
end Behavioral;