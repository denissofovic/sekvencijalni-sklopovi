LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top_tb IS
END top_tb;
ARCHITECTURE arctop_tb OF top_tb IS
    COMPONENT top
        PORT (
            in1 : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            out1 : out STD_LOGIC_VECTOR (2 downto 0)
           -- out1 : OUT INTEGER
        );
    END COMPONENT;
    SIGNAL in1 : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL out1: std_logic_vector(2 downto 0);
    --SIGNAL out1 : INTEGER;
BEGIN
    
    uut : top PORT MAP(
        in1 => in1,
        out1 => out1
    );
    stim_proc : PROCESS
    BEGIN
        WAIT FOR 100 ns;
        in1 <= "000001";
        WAIT FOR 100 ns;
        in1 <= "000011";
        WAIT FOR 100 ns;
        in1 <= "000111";
        WAIT FOR 100 ns;
        in1 <= "001111";
        WAIT FOR 100 ns;
        WAIT;
    END PROCESS;
END;