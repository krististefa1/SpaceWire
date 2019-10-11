library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity my_parity is
	port ( clock, resetn: in std_logic;
	       di: in std_logic_vector(8 downto 0);
		   do: out std_logic_vector(9 downto 0)); 
end my_parity;

architecture bhv of my_parity is

component regNbit is 
 generic (n:integer :=4);
 Port (load: in std_logic;
       clk: in std_logic;
       clr: in std_logic;
       d: in std_logic_vector(N-1 downto 0);
       q: out std_logic_vector(N-1 downto 0));
end component;        
signal encodeOut: std_logic_vector(9 downto 0);
signal do1: std_logic_vector(8 downto 0);
signal do2: std_logic_vector(9 downto 0);
signal pbit: std_logic;
begin 

word2: regNbit generic map(N=>9)
                port map(clk=>clock, clr=>'0', d=>di, q=>do1, load=>'1');
                
word1: regNbit generic map(N=>10)
                port map(clk=>clock, clr=>'0', d=>do2,load=>'1',q=>encodeOut);

process (encodeOut)
begin              
if encodeOut(8 downto 0)="111010000" then pbit <= not(do1(8) xnor encodeOut(0) xnor encodeOut(1)); 
else                 
pbit<=not(do1(8) xnor encodeOut(7) xnor encodeOut(6) xnor encodeOut(5) xnor encodeOut(4)
                xnor encodeOut(3) xnor encodeOut(2) xnor encodeOut(1) xnor encodeOut(0));
                end if;
                end process;               
do2<= pbit& do1;
do<=encodeOut;                
end bhv;