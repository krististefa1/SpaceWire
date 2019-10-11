library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftReg is
    Port ( D : in STD_LOGIC;
           Q : out STd_logic_vector(1 downto 0);
           ld : in STD_LOGIC;
           mclk : in STD_LOGIC;
           clr : in STD_LOGIC);
end ShiftReg;

architecture Behavioral of ShiftReg is
component Registers is
    Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           en : in std_logic;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC);
end component;
signal D_one: std_logic;
begin
Regone: Registers port map(clk => mclk, clr => clr, D => D, Q => D_one, en => ld); --these two registers store the new and previous data bits 
Regtwo: Registers port map(clk => mclk, clr => clr, D => D_one, Q => Q(1), en => ld); --from the Data strobe
Q(0) <= D_one;
end Behavioral;
