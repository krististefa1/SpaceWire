library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receiver is
    Port ( mclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           D : in STD_LOGIC;
           S : in STD_LOGIC;
           Enable : in STD_LOGIC;
           gotFCT : out STD_LOGIC;
           gotNChar : out STD_LOGIC;
           gotTime_Code : out STD_LOGIC;
           gotNULL : out STD_LOGIC;
           gotBit : out STD_LOGIC;
           CreditErr : out STD_LOGIC;
           RxError : out STD_LOGIC;
           Control_flags_out : out STD_LOGIC_VECTOR (1 downto 0);
           Time_out : out STD_LOGIC_VECTOR (5 downto 0);
           Tick_out : out STD_LOGIC;
           RecClk : out STD_LOGIC;
           BufferReady : in STD_LOGIC;
           RxData : out STD_LOGIC_VECTOR (7 downto 0);
           Control_flag : out std_logic;
           BufferWrite : out STD_LOGIC);
end Receiver;

architecture Behavioral of Receiver is

component DataRead is
    Port ( D : in STD_LOGIC;
           S : in STD_LOGIC;
           RxErr : out STD_LOGIC;
           Data1 : out STD_LOGIC_VECTOR (7 downto 0);
           Data2 : out STD_LOGIC_VECTOR (1 downto 0);
           getData1 : out std_logic;
           getData2 : out std_logic;
           clk : in STD_LOGIC;
           enall : in std_logic;
           reset : in STD_LOGIC);
end component;

component Data1 is
    Port ( Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0);
           Dld : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC);
end component;

component Timeout is 
    Port ( mclk : in STD_LOGIC;
           DisErr : out STD_LOGIC;
           Enable : in std_logic;
           D : in STD_LOGIC;
           clr : in STD_LOGIC);
end component;

component ControlFSM is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           enall : in STD_LOGIC;
           cld : in STD_LOGIC;
           dld : in STD_LOGIC;
           Control : in STD_LOGIC_VECTOR (1 downto 0);
           gotFCT : out STD_LOGIC;
           gotNULL : out STD_LOGIC;
           gotTime_Code : out STD_LOGIC;
           gotNChar : out STD_LOGIC;
           E_OP : out std_logic;
           E_EP : out std_logic;
           ESCErr : out std_logic;
           ldNchar : out STD_LOGIC;
           ldTimeCode : out STD_LOGIC);
end component;

component MainFSM is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           EnFSM : in STD_LOGIC;
           D : in STD_LOGIC;
           S : in STD_LOGIC;
           NULLs : in STD_LOGIC;
           enall : out STD_LOGIC;
           gBit : out std_logic;
           disen : out STD_LOGIC);
end component;

component N_Chars is
    Port ( Data : in STD_LOGIC_VECTOR (7 downto 0);
           RxData : out STD_LOGIC_VECTOR (7 downto 0);
           Control_flag : out std_logic;
           BuffWrite : out STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           DataRec : in std_logic;
           E_OP : in std_logic;
           E_EP : in std_logic;
           BuffReady : in STD_LOGIC;
           CreditErr : out STD_LOGIC);
end component;

component RxClk is
    Port ( D : in STD_LOGIC;
           S : in STD_LOGIC;
           Rclk : out STD_LOGIC);
end component;

component RxErr is
    Port ( clk : in STD_LOGIC;
           Parity : in STD_LOGIC;
           ESC : in STD_LOGIC;
           DisErr : in STD_LOGIC;
           enall : in STD_LOGIC;
           RxEr : out STD_LOGIC);
end component;

component Time_Codes is
    Port ( Data : in STD_LOGIC_VECTOR (7 downto 0);
           Time_Code : in STD_LOGIC;
           Tick_out : out STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           TimeOut : out STD_LOGIC_VECTOR (5 downto 0);
           Flags : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component ClkFSM is
    Port ( mclk : in STD_LOGIC;
           Rclk : in STD_LOGIC;
           reset : in std_logic;
           clk : out STD_LOGIC);
end component;

signal ParityErr,RxE, clk, Dld, Cld, DisconnectErr, disen, enall, NC, TC, ESC , NUL, clk2 : std_logic;
signal Data, Dout : std_logic_vector(7 downto 0);
signal Control, Cout : std_logic_vector(1 downto 0);
signal Disconnecterror, E_OP, E_EP : std_logic;

begin
RxError <= RxE or DisconnectErr;
Datar: DataRead port map(D => D, S => S, enall => enall, RxErr => ParityErr, Data1 => Data, Data2 => Control, getData1 => Dld, 
        getData2 => Cld, clk => clk, reset => reset);
Reg: Data1 port map(Din => Data, Dout => Dout, Dld => Dld, clr => reset, clk => clk);
Timer: Timeout port map(mclk => mclk, DisErr => DisconnectErr, Enable => disen, D => D, clr => reset); 
CFSM: ControlFSM port map(clk => clk, clr => reset, enall => enall, cld => Cld, dld => Dld, Control => Control,--Cout,
     gotFCT => gotFCT, gotNull => NUL, gotTime_Code => gotTime_Code, gotNChar => gotNChar, ESCErr => ESC, 
        ldNchar => NC, ldTimeCode => TC, E_OP => E_OP, E_EP => E_EP);
MFSM: MainFSM port map(rst => reset, clk => clk, EnFSM => Enable, D => D, S => S, NULLs => NUL, 
    enall => enall, gBit => gotBit, disen => disen);
NChar: N_Chars port map(Data => Dout, RxData => RxData, BuffWrite => BufferWrite, clk => clk, clr => reset, 
        DataRec => NC, BuffReady => BufferReady, CreditErr => CreditErr, E_OP => E_OP, E_EP => E_EP, Control_flag => Control_flag);
ReceClk: RxClk port map(Rclk => clk2, D => D, S => S);
RErr: RxErr port map(clk => clk, Parity => ParityErr, ESC => ESC, DisErr => DisconnectErr, 
        enall => enall, RxEr => RxE);
TimCod: Time_Codes port map(Data => Dout, Time_Code => TC, Tick_out => Tick_out, clk => clk, 
        clr => reset, TimeOut => Time_out, Flags => Control_flags_out);
clkFS: ClkFSM port map(mclk => mclk, Rclk => clk2, reset => reset, clk => clk);
gotNULL <= NUL;
RecClk <= clk;
end Behavioral;
