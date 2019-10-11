library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Time_Codes is
    Port ( Data : in STD_LOGIC_VECTOR (7 downto 0);
           Time_Code : in STD_LOGIC;
           Tick_out : out STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           TimeOut : out STD_LOGIC_VECTOR (5 downto 0);
           Flags : out STD_LOGIC_VECTOR (1 downto 0));
end Time_Codes;

architecture Behavioral of Time_Codes is

begin
    process(Time_Code, Data, clk, clr)
        begin
            if clr = '1' then --when the receiver is reset
                Tick_out <= '0';
                TimeOut <= "000000";
                Flags <= "00";
            elsif rising_edge(clk) then
                if Time_Code = '1' then --A time-code has been received
                    TimeOut <= Data(5 downto 0); --puts the bottom 5 bits on the time out lines
                    Flags <= Data(7 downto 6); --puts the top two bits on the Flags line
                    Tick_out <= '1'; --tells system that the data is ready
                else
                    Tick_out <= '0'; --tells system no data is ready 
                    TimeOut <= "000000";
                    Flags <= "00";
                end if;
            end if;
    end process;
end Behavioral;
