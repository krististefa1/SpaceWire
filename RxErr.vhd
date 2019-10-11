library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RxErr is
    Port ( clk : in STD_LOGIC;
           Parity : in STD_LOGIC;
           ESC : in STD_LOGIC;
           DisErr : in STD_LOGIC;
           enall : in STD_LOGIC;
           RxEr : out STD_LOGIC);
end RxErr;

architecture Behavioral of RxErr is

begin
    process(clk, Parity, ESC, DisErr, enall)
        begin
            RxEr <= '0';
            if rising_edge(clk) then
                if enall = '1' then
                    if ESC = '1' or Parity = '1' then --only detected when the reciever is in the final state 
                        RxEr <= '1'; 
                    end if;
                elsif DisErr = '1' then --this can only be high when the reciever is in the 3rd or 4th state
                    RxEr <= '1';
                end if;
            end if;
    end process;           
end Behavioral;
