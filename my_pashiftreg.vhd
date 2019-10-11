---------------------------------------------------------------------------
-- This VHDL file was developed by Daniel Llamocca (2018).  It may be
-- freely copied and/or distributed at no cost.  Any persons using this
-- file for any purpose do so at their own risk, and are responsible for
-- the results of such use.  Daniel Llamocca does not guarantee that
-- this file is complete, correct, or fit for any particular purpose.
-- NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
-- accompany any copy of this file.
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity my_pashiftreg is
   generic (N: INTEGER:= 10);
								 --The current orientation is left shifts so adjustment is needed if right
	port ( clock, resetn: in std_logic;
	       --din: in std_logic; not needed because a 10 to 1 shift with no din
		   D: in std_logic_vector (N-1 downto 0);
	       Q: out std_logic_vector (N-1 downto 0);
	       enOut: in std_logic;
          shiftout: out std_logic);
end my_pashiftreg;

architecture Behavioral of my_pashiftreg is

signal Qt: std_logic_vector (N-1 downto 0);
signal count: integer range 0 to N-1;  --parametric way to load new data for every length
signal check: std_logic;
signal check2: std_logic;
begin
process (resetn, clock, enOut)
    begin
if resetn = '1' then Qt <= (others=>'0'); 
count<= N-1;  
shiftout<='0';
check<='0';
elsif (clock'event and clock = '1' and enOut='1') then
   
	   if count= N-1 then 
	       Qt <= D(8 downto 0) & '0';
	       shiftout<= D(9);
	   if D(8) = '1' then check<='1';
	       if D(4) = '0' then check2<='1';
	       else check2<='0'; end if;
	   
	   else check <= '0'; end if;
	   
	   count <=0;
	  
	   else
			for i in 1 to N-1 loop
				Qt(i) <= Qt(i-1);
				Qt(0) <= '0';
			end loop;
			if check = '1' then
			 shiftout <= Qt(N-1);
			else 
			 shiftout <= Qt(N-1);
			end if;
	   count <= count+1;
	   if (count=6 and check='1') or (count=2 and check2='1') then
	   count<=N-1;
	   end if;
	   end if;
                    
end if;
end process;

Q <= Qt; 
end Behavioral;
