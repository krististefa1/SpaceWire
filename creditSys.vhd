library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity creditSys is 
	port (clock, resetn, gotFCT: in std_logic;
			credit: out std_logic_vector(2 downto 0)); 
	end creditSys;
	
architecture behavior of creditSys is 
	signal tick: std_logic_vector(2 downto 0); --Signal to check whether FCT assertions are distinct or continued
	signal count: integer range 0 to 7; --tally before being converted
	
		begin 
		 process (resetn, clock)
		  begin	
			if resetn = '1' then
				credit<="000";
				count<=0;
			elsif (clock'event and clock='1') then	
				tick(0) <= gotFCT;
				tick(1) <= tick(0);
				tick(2) <= tick(1);
				
				if tick="001" or tick = "101" then	--only increment on new assertions or distinct assertions
					count<=count + 1;
				end if;
				
				credit<=conv_std_logic_vector(count, 3);
			end if;
		 end process;
		end behavior;