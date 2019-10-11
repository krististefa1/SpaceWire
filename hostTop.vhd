----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2019 12:25:35 AM
-- Design Name: 
-- Module Name: hostTop - Behavioral
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

entity hostTop is
  Port (mclk: in std_logic;
        btn: in std_logic_vector(1 downto 0);
        tickIn: out std_logic;
        TX_Ready: in std_logic;
        TX_Write: out std_logic;  
        TX_Data: out std_logic_vector(7 downto 0);
        TX_Time: out std_logic_vector(7 downto 0);
        RX_Data: in std_logic_vector(7 downto 0);
        RX_Ready: out std_logic;
        RX_Write: in std_logic;
        tickOut: in std_logic;
        endPacket: in std_logic;
        dataReady: out std_logic;
        RX_Time: in std_logic_vector(7 downto 0);
        an: out std_logic_vector(3 downto 0);
        dp: out std_logic;
        a_to_g: out std_logic_vector(6 downto 0);
        sw: in std_logic_vector(15 downto 0));
end hostTop;

architecture Behavioral of hostTop is

component displayMUX is
    Port ( a : in STD_LOGIC_VECTOR (63 downto 0);
           b : in STD_LOGIC_VECTOR (63 downto 0);
           c : in STD_LOGIC_VECTOR (63 downto 0);
           d : in STD_LOGIC_VECTOR (63 downto 0);
           e : in STD_LOGIC_VECTOR (63 downto 0);
           f : in STD_LOGIC_VECTOR (63 downto 0);
           g : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC_VECTOR (5 downto 0);
           word : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal word: std_logic_vector(7 downto 0);
signal chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7: std_logic_vector(63 downto 0);
signal sel: std_logic_vector(5 downto 0);
signal clr: std_logic;

component x7segb is
	 port(
		 x : in STD_LOGIC_VECTOR(15 downto 0);
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 a_to_g : out STD_LOGIC_VECTOR(6 downto 0);
		 an : out STD_LOGIC_VECTOR(3 downto 0);
		 dp : out STD_LOGIC
	     );
end component;

component reg8 is 
 port (clock, resetn, en: in std_logic;
        di: in std_logic_vector(7 downto 0);
        q: out std_logic_vector (7 downto 0));
  end component;
  
signal timeIn: std_logic_vector(7 downto 0);

component tickCounter is
    Port ( clock : in STD_LOGIC;
           tickIn: out std_logic;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component RXFSM is
 Port (clock: in std_logic;
       reset: in std_logic;
       RX_Write: in std_logic;
       RX_Ready: out std_logic;
       endPacket: in std_logic;
       dataReady: out std_logic;
       storEn: out std_logic_vector(6 downto 0));
end component;

signal storEn: std_logic_vector(6 downto 0);

component chunkReg is
    Port ( data : in STD_LOGIC_VECTOR (7 downto 0);
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           contents : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component TXFSM is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           TX_Ready : in STD_LOGIC;
           TX_Write : out STD_LOGIC);
end component;

begin
clr<=btn(1);
sel<=sw(5 downto 0);
f0: displayMUX port map (a=>chunk1, b=>chunk2, c=>chunk3, d=>chunk4, e=>chunk5, f=>chunk6, g=>chunk7,
                            sel=>sel, word=>word);
f1: x7segb port map(x(15 downto 8)=>x"00", x(7 downto 0)=>word, clk=>mclk, clr=>clr, a_to_g=>a_to_g,
                           an=>an, dp=>dp); 
timeReg: reg8 port map (clock=>mclk, resetn=>clr, en=>tickOut, di=>RX_Time, q=>timeIn);
dataReg: reg8 port map (clock=>mclk, resetn=>clr, en=>btn(0), di=>sw(15 downto 8), q=>TX_Data);  
f2: tickCounter port map (clock=>mclk, tickIn=>tickIn, reset=>clr, count=>TX_Time);
f3: RXFSM port map (clock=>mclk, reset=>clr, RX_Write=>RX_Write, RX_Ready=>RX_Ready, endPacket=>endPacket,
                                    dataReady=>dataReady, storEn=>storEn);
f4: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(0), contents=>chunk1);
f5: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(1), contents=>chunk2);
f6: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(2), contents=>chunk3);
f7: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(3), contents=>chunk4);
f8: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(4), contents=>chunk5);
f9: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(5), contents=>chunk6);
f10: chunkReg port map (clock=>mclk,reset=>clr, data=>RX_Data, en=>storEn(6), contents=>chunk7);   

f11: TXFSM port map (clock=>mclk, reset=>clr, TX_Ready=>TX_Ready, TX_Write=>TX_Write);
end Behavioral;
