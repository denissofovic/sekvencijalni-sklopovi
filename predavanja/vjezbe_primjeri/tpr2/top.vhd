library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port(
        fclk: in std_logic;
        a, b: in unsigned (3 downto 0) := (others => '0');
        out1: out unsigned (3 downto 0) := (others => '0'); -- Make 'out1' 5bit value, try without carry bit 
        carry: out std_logic                                -- and without concatenation operator ie '&'
    );
end top;



architecture arctop of top is
    begin

        main: process(fclk)
        variable tsum: unsigned (3 downto 0);

        begin
            if rising_edge(fclk) then

                tsum := a + b;
                if a >= b then
                    if a > tsum then
                        carry <= '1';
                    else
                        carry <= '0';
                    end if;
                else
                    if b > tsum then
                        carry <= '1';
                    else
                        carry <= '0';
                    end if;
                end if;


                out1 <= tsum;
            
            end if;
        end process;

            

end arctop;