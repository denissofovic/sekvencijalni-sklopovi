library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

--write top_tb.vhd for this one
entity top is
    port(
        A: in std_logic;
        B: in std_logic;
        C: in std_logic;
        D: in std_logic;
        F: out std_logic := (others => '0')
    );
end top;

architecture arctop of top is
    F <= ((A OR B) AND (NOT C)) OR (((B AND (NOT D)) OR (C AND (NOT A))) AND D);
end arctop;
