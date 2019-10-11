----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2018 10:10:44 AM
-- Design Name: 
-- Module Name: TX_top - Behavioral
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

entity TX_top is
 Port (sysTime_In: in std_logic_vector(7 downto 0);
       tickIn: in std_logic;
       data_In: in std_logic_vector(7 downto 0);
       newData: in std_logic;
       clock: in std_logic;
       state: in std_logic_vector(1 downto 0);
       reset: in std_logic;
       gotFCT: in std_logic;
       RX_Ready: in std_logic;
       d: out std_logic;
       s: out std_logic
        );
end TX_top;

architecture Behavioral of TX_top is
component storage_top is 
   Port ( clock : in STD_LOGIC;
           resetn : in STD_LOGIC;
           newData: in std_logic;
           en : in STD_LOGIC;
           mode: in std_logic;
		   data: in std_logic_vector(7 downto 0);
           dchar : out STD_LOGIC_VECTOR (7 downto 0));
end component;


component codeBlock is 
Port ( resetn : in STD_LOGIC;
           clock : in STD_LOGIC;
		   request: in std_logic_vector(2 downto 0);
           code : out STD_LOGIC_VECTOR (8 downto 0));
end component;

component creditSys is
 port (clock, resetn, gotFCT: in std_logic;
			credit: out std_logic_vector(2 downto 0)); 
end component;

component mainTXFSM is 
 Port ( resetn : in STD_LOGIC;
          clock : in STD_LOGIC;
          state: in STD_LOGIC_VECTOR(1 downto 0);
          tickIn: in STD_LOGIC; --signal from host when sending time-code
          enOut: out STD_LOGIC; --enable for 10 to 1 block
          enIn: out std_logic; --enable for the 1 to 8 block
          sel : out STD_LOGIC_vector(1 downto 0); --select for code char MUX
          request: out STD_LOGIC_VECTOR(2 downto 0)); --requests for certain codes
end component;

component my_parity is
port ( clock, resetn: in std_logic;
	       di: in std_logic_vector(8 downto 0);
		   do: out std_logic_vector(9 downto 0)); 
end component;

component my_pashiftreg is
 generic (N: INTEGER:= 10);
                                --The current orientation is left shifts so adjustment is needed if right
   port ( clock, resetn: in std_logic;
          enOut: in std_logic;
          D: in std_logic_vector(N-1 downto 0);
          Q: out std_logic_vector (N-1 downto 0);
         shiftout: out std_logic);
end component;

component inputCounter is 
Port (newData: in std_logic;
        resetn: in std_logic;
        clock: in std_logic;
        fctReady: out std_logic;
        blockSel: out std_logic_vector(2 downto 0)
        );
end component;
        
component deMUX8to1 is
Port ( a : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0);
           c : out STD_LOGIC_VECTOR (7 downto 0);
           d : out STD_LOGIC_VECTOR (7 downto 0);
           e : out STD_LOGIC_VECTOR (7 downto 0);
           f : out STD_LOGIC_VECTOR (7 downto 0);
           i : out STD_LOGIC_VECTOR (7 downto 0);
           j : out std_logic_vector (7 downto 0);
           wr_rd : in STD_LOGIC;
           --regEn: out std_logic_vector(7 downto 0);
           address : in STD_LOGIC_VECTOR (2 downto 0);
           h : in STD_LOGIC_VECTOR (7 downto 0));
 end component;

component regDecoder is
Port ( inSel : in STD_LOGIC_VECTOR (2 downto 0);
           mode: in std_logic;
           regEn : out STD_LOGIC_VECTOR (7 downto 0);
           outSel : in STD_LOGIC_VECTOR (2 downto 0));
 end component;
            
 component MUX8to1 is
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
end component;

component DS_encoder is
port (clock, resetn, en: in std_logic;
        di: in std_logic;  --the current output of D, a wire from the 10 to 1 block
		--s: in std_logic; --most recent output
        do: out std_logic;
        so: out std_logic);
end component;

component dataFSM is 
Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           fctReady : in STD_LOGIC;
           RX_Ready: in std_logic;
           mode: out std_logic;
           count : in STD_LOGIC_VECTOR (2 downto 0);
           --regEn : out STD_LOGIC_VECTOR (6 downto 0);
           muxSel : out STD_LOGIC_VECTOR (2 downto 0));
end component;           
           
signal timeIn: std_logic_vector(7 downto 0);
signal storDataIn: std_logic_vector(7 downto 0);
signal storDataOut: std_logic_vector(7 downto 0);
signal dataPulse: std_logic_vector(2 downto 0); --this pulses with new data on bus
signal dataReady: std_logic; --signal to transition the storage registers
--signal dataMUXen: std_logic;
signal enIn,enOut: std_logic;


signal credit: std_logic_vector(2 downto 0);

signal i1,i2,i3,i4,i5,i6,i7: std_logic_vector(7 downto 0); --deMUX to storage connections
signal o1,o2,o3,o4,o5,o6,o7: std_logic_vector(7 downto 0); --storage to MUX connection
--signal readSel: std_logic_vector(7 downto 0);
--signal writeSel: std_logic_vector(7 downto 0);

signal regEn: std_logic_vector(7 downto 0);
signal blockSel: std_logic_vector(2 DOWNTO 0);
signal fctReady: std_logic;
signal blockSelOut: std_logic_vector(2 downto 0);

signal codeRequest: std_logic_vector(2 downto 0); --code request from FSM to block
signal codeOut: std_logic_vector(8 downto 0);
signal outSel: std_logic_vector(1 downto 0); --signal that alters what kind of data gets shifted out
signal mode: std_logic;

signal parityIn: std_logic_vector(8 downto 0);
signal parityOut: std_logic_vector(9 downto 0);

signal encodeIn: std_logic;
              --signals governing final output encoder
signal encodeOutS: std_logic;
signal encodeOutD: std_logic;
begin
storDataIn<=data_In;
newPulse: process(clock, reset)  --pulse process connected to data registers
begin
        if reset = '0' then
    dataPulse<="000";
elsif (clock'event and clock='1') then
dataPulse(0)<=newData;
dataPulse(1)<=dataPulse(0);
dataPulse(2)<=dataPulse(1);
end if;
dataReady<=not(dataPulse(1)) and dataPulse(0); --only allow "101" and "001";
end process;

fctReady<='1';
f0: deMUX8to1 port map(a=>i1,b=>i2,c=>i3,d=>i4,e=>i5,f=>i6,i=>i7, wr_rd=>enIn, address=>blockSel, h=>storDataIn);
f1: MUX8to1 port map(a=>o1,b=>o2, c=>o3, d=>o4,e=>o5,f=>o6,i=>o7, j=>"00000000", address=>blockSelOut, h=>storDataOut);
s0: dataFSM port map(clock=>clock, reset=>reset,fctReady=>fctReady,mode=>mode,count=>credit,muxSel=>blockSelOut,RX_Ready=>RX_Ready);
f6: regDecoder port map(inSel=>blockSel, outSel=>blockSelOut, regEn=>regEn,mode=>mode);
f2: inputCounter port map(newData=>dataReady, clock=>clock, resetn=>reset, blockSel=>blockSel, fctReady=>fctReady);
s1: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(0),data=>i1,dchar=>o1);
s2: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(1),data=>i2,dchar=>o2);
s3: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(2),data=>i3,dchar=>o3);
s4: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(3),data=>i4,dchar=>o4);
s5: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(4),data=>i5,dchar=>o5);
s6: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(5),data=>i6,dchar=>o6);
s7: storage_top port map (clock=>clock, resetn=>reset, newData=>dataReady, mode=>mode, en=>regEn(6),data=>i7,dchar=>o7);
f3: creditSys port map(clock=>clock, resetn=>reset, gotFCT=>gotFCT, credit=>credit);
f4: codeBlock port map(clock=>clock,resetn=>reset,request=>codeRequest,code=>codeOut);
f5: mainTXFSM port map(clock=>clock,resetn=>reset,state=>state,tickIn=>tickIn,enIn=>enIn,enOut=>enOut,sel=>outSel,request=>codeRequest);


timeIn<=sysTime_In;
OutMux: process(outSel,timeIn,storDataOut,codeOut)
begin 
case outSel is
    when "00" =>
        parityIn<='0'& timeIn;
    when "01"=>  
    if storDataOut /= "00000000" then                      --data is supposed to transmitted LSB to MSB
        parityIn<='0'& storDataOut;
    else parityIn<="1110100" & "00"; end if;  
    when "10"=>
        parityIn<=codeOut;
    when others=>
        parityIn<="000000000"; 
end case;                    
end process;

f9: my_parity port map(clock=>clock,resetn=>reset,di=>parityIn,do=>parityOut);
f7: my_pashiftreg port map(clock=>clock,resetn=>reset,d=>parityOut,enOut=>enOut, shiftOut=>encodeIn);
f8:DS_encoder port map (clock=>clock,resetn=>reset,di=>encodeIn,so=>encodeOutS, do=>EncodeOutD, en=>enOut);
d<=encodeOutD;
s<=encodeOutS;
end Behavioral;
