LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top IS
    PORT (
        in1 : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        out1 : out STD_LOGIC_VECTOR (2 downto 0));
        --out1 : OUT INTEGER);
END top;


ARCHITECTURE arctop OF top IS
BEGIN
    PROCESS (in1)
        VARIABLE count : unsigned(2 DOWNTO 0) := "000";
    BEGIN
        count := "000";
        FOR i IN 0 TO 5 LOOP
            
            IF (in1(i) = '1') THEN 
                --count := count + 1; 
                count := count + ("000" & in1(i)); --avoid the use of concatenation operator ie '&', try something else?
                
            END IF;
        END LOOP;
        --out1 <= to_integer(count);
        out1 <= std_logic_vector(count);
    END PROCESS;
END arctop;