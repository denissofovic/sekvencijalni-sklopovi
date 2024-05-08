library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        abc: in std_logic_vector(2 downto 0);
        Y: out std_logic_vector( 7 downto 0)
    );
end top;

architecture arctop of top is

    begin
        Y <= "00000001" when (abc =  "000") else
             "00000010" when (abc =  "001") else
             "00000100" when (abc =  "010") else
             "00001000" when (abc =  "011") else
             "00010000" when (abc =  "100") else
             "00100000" when (abc =  "101") else
             "01000000" when (abc =  "110") else
             "10000000" when (abc =  "111"); 

end arctop;