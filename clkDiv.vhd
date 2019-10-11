library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkdiv is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           halfclk : out STD_LOGIC);
end clkdiv;

architecture Behavioral of clkdiv is
signal q:std_logic_vector(23 downto 0);
begin
process(mclk, clr)
begin
if clr='1' then
    q<=x"000000"; 
elsif mclk'event and mclk='1' then
    q<=q+1;
end if;    
end process;
halfclk<=q(0);
end Behavioral;