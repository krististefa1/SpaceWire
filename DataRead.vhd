library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataRead is
    Port ( D : in STD_LOGIC;
           S : in STD_LOGIC;
           RxErr : out STD_LOGIC;
           Data1 : out STD_LOGIC_VECTOR (7 downto 0);
           Data2 : out STD_LOGIC_VECTOR (1 downto 0);
           getData1 : out std_logic;
           getData2 : out std_logic;
           enall : in std_logic;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end DataRead;

architecture Behavioral of DataRead is

component ShiftRegisters is
    Port ( D : in STD_LOGIC;
           En : in STD_LOGIC;
           clk : in STD_LOGIC;
           control : out std_logic;
           Data : out STD_LOGIC_VECTOR (7 downto 0);
           Data2 : out std_logic_vector (1 downto 0);
           Parity : out std_logic;
           Parity2 : out std_logic;
           reset : in std_logic);
end component;

component FSM is
    Port ( D : in STD_LOGIC;
           control : in std_logic;
           S : in STD_LOGIC;
           clk : in std_logic;
           enall : in std_logic;
           reset : in std_logic;
           parity : in STD_LOGIC;
           parity2 : in std_logic;
           encount : out std_logic;
           countdone : in std_logic;
           enreg : out STD_LOGIC;
           RxErr : out std_logic;
           getData1 : out STD_LOGIC; ---for data characters
           getData2 : out STD_LOGIC); ---for control characters
end component;

component counter is
    Port ( clk : in STD_LOGIC;
           En : in STD_LOGIC;
           count : out STD_LOGIC;
           reset : in STD_LOGIC);
end component;

signal en, p, p2, p3, ecount, count1, control1 : std_logic;
begin

f0: ShiftRegisters port map(D => D, control => control1, En => en, clk => clk, Data => Data1, Data2 => Data2, Parity => p, Parity2 => p2, reset => reset);
f1: FSM port map(D => D, control => control1, enall => enall, S => S, clk => clk, reset => reset, parity => p2, parity2 => p, encount => ecount, countdone => count1, 
        enreg => en, RxErr => RxErr, getData1 => getData1, getData2 => getData2);
f2: counter port map(clk => clk, En => ecount, count => count1, reset => reset);


end Behavioral;
