
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Timeout is --only component in the reciever that uses the master clock instead of the reciever clock
    Port ( mclk : in STD_LOGIC;
           DisErr : out STD_LOGIC;
           Enable : in std_logic;
           D : in STD_LOGIC;
           clr : in STD_LOGIC);
end Timeout;

architecture Behavioral of Timeout is
component ShiftReg is
    Port ( D : in STD_LOGIC;
           Q : out STd_logic_vector(1 downto 0);
           ld : in STD_LOGIC;
           mclk : in STD_LOGIC;
           clr : in STD_LOGIC);
end component;

component DisconnectError is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           enable : in STD_LOGIC;
           Q : in std_logic_vector(1 downto 0);
           Error : out STD_LOGIC);
end component;

signal qt: std_logic_vector(1 downto 0);--used to connect the values that are used to test if the data has changed
--if data has not changed in 850 ns then the component asserts a disconnect error causing the Recevier to be reset
begin
f0: ShiftReg port map(D => D, Q => qt, ld => Enable, mclk => mclk, clr => clr);
f1: DisconnectError port map(mclk => mclk, clr => clr, enable => Enable, Q => qt, Error => DisErr);

end Behavioral;
