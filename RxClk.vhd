library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RxClk is
    Port ( D : in STD_LOGIC;
           S : in STD_LOGIC;
           Rclk : out STD_LOGIC);
end RxClk;

architecture Behavioral of RxClk is
signal clk : std_logic;

begin
    process(D, S, clk)
        begin
    clk <= D xor S;--the falling and rising edge of this signal is used as a clock throughout the Receiver

    end process;
    Rclk <= clk;

end Behavioral;
