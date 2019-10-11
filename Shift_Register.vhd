library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_Register is
    Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           clk : in STD_LOGIC;
           En : in STD_LOGIC;
           reset : in STD_LOGIC);
end Shift_Register;

architecture Behavioral of Shift_Register is
signal qt : std_logic;
begin
process(clk, En, reset, qt, D)
    begin
        if reset = '1' then
            qt <= '0';
        elsif rising_edge(clk) then
            if En = '1' then
                qt <= D;
            else
                qt <= qt;
            end if;
        end if;
        
    end process;  
    Q <= qt;                  
end Behavioral;
