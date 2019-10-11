library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_Chars is
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
end N_Chars;

architecture Behavioral of N_Chars is

begin
    process(clk, clr, BuffReady, Data)
        begin
            if clr = '1' then --when the system is reset
                RxData <= X"00"; --reset the lines
                BuffWrite <= '0';
                CreditErr <= '0';
                Control_flag <= '0';
            elsif rising_edge(clk) then
                if DataRec = '1' then --if NChar is received
                    if BuffReady = '1' then --if the host system is wanting data
                        if E_OP = '1' then
                            RxData <= X"00";
                            BuffWrite <= '1';
                            Control_flag <= '1';
                        elsif E_EP = '1' then
                            RxData <= "00000001";
                            BuffWrite <= '1';
                            Control_flag <= '1';
                        else
                            RxData <= Data; --send the data that was received
                            BuffWrite <= '1'; --tell the system that the Data is ready
                            Control_flag <= '0';
                        end if;
                    else
                        CreditErr <= '1'; --if the system is not ready when data is received then a credit error has occured
                    end if;
                else
                    RxData <= X"00"; 
                    BuffWrite <= '0'; --receiver is not giving any data to host
                end if;
           end if;
   end process;
end Behavioral;
