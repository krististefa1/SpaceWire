library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegisters is
    Port ( D : in STD_LOGIC;
           En : in STD_LOGIC;
           clk : in STD_LOGIC;
           Data : out STD_LOGIC_VECTOR (7 downto 0);
           Data2 : out std_logic_vector (1 downto 0);
           Parity : out std_logic;
           Parity2 : out std_logic;
           control : out std_logic;
           reset : in std_logic);
end ShiftRegisters;

architecture Behavioral of ShiftRegisters is

component Shift_Register is
    Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;           
           clk : in STD_LOGIC;
           En : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

signal qt : std_logic_vector (9 downto 0);

begin

f0: Shift_Register port map(D => D, Q => qt(0), clk => clk, En => En, reset => reset);
f1: Shift_Register port map(D => qt(0), Q => qt(1), clk => clk, En => En, reset => reset);
f2: Shift_Register port map(D => qt(1), Q => qt(2), clk => clk, En => En, reset => reset);
f3: Shift_Register port map(D => qt(2), Q => qt(3), clk => clk, En => En, reset => reset);
f4: Shift_Register port map(D => qt(3), Q => qt(4), clk => clk, En => En, reset => reset);
f5: Shift_Register port map(D => qt(4), Q => qt(5), clk => clk, En => En, reset => reset);
f6: Shift_Register port map(D => qt(5) , Q => qt(6), clk => clk, En => En, reset => reset);
f7: Shift_Register port map(D => qt(6), Q => qt(7), clk => clk, En => En, reset => reset);
f8: Shift_Register port map(D => qt(7), Q => qt(8), clk => clk, En => En, reset => reset);
f9: Shift_Register port map(D => qt(8), Q => qt(9), clk => clk, En => En, reset => reset);
Data <= qt(9 downto 2);--used to get the 8 bits of data  --qt(7 downto 0);
Data2 <= qt(3 downto 2);--used to get the control character --qt(1 downto 0)
Parity <= (qt(0) xnor qt(1) xnor qt(2) xnor qt(3) xnor qt(4) xnor qt(5) xnor qt(6) xnor qt(7) xnor qt(8) xnor qt(9));
Parity2 <= (qt(0) xnor qt(1) xnor qt(2) xnor qt(3));--both parities check for odd parity
control <= qt(0);--control character read by the FSM to know if 8 bits are coming or only 2 control bits
end Behavioral;
