library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity DS_encoder is 
 port (clock, resetn, en: in std_logic;
        di: in std_logic;  --the current output of D, a wire from the 10 to 1 block
		--s: in std_logic; --the output of the external xnor gate
        do: out std_logic;
        so: out std_logic);
  end DS_encoder;
  
architecture Behavioral of DS_encoder is
component FSMEncode is
    Port ( Do : in STD_LOGIC;
           D : in STD_LOGIC;
           S : out STD_LOGIC;
           en : in std_logic;
           clk : in std_logic;
           clr : in std_logic);
end component;

component Reg is
    Port ( Din : in STD_LOGIC;
           Dout : out STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           ld : in STD_LOGIC);
end component;

    signal D : std_logic_vector(1 downto 0);

begin

FS: FSMEncode port map(Do => D(0), en => en, D => di, S => so, clk => clock, clr => resetn);
Reg1: Reg port map(Din => di, Dout => D(0), clk => clock, clr => resetn, ld => en);
Reg2: Reg port map(Din => D(0), Dout => D(1), clk => clock, clr => resetn, ld => en);
do <= D(0);
end Behavioral;
     
        