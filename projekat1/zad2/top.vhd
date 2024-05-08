library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    port (
        ina: in std_logic;
        inb: in std_logic;
        cwout: out std_logic := '0';
        ccwout: out std_logic:= '0';
        fclk: in std_logic
    );
end top;


architecture arctop of top is


begin
    main:process(fclk) 
    variable state: integer := 0;
    
    begin
        if falling_edge(fclk) then
            
            if inb = '1' and falling_edge(ina) then
                state := 1;
            end if;

            if ina = '1' and falling_edge(inb) then
                state := 2;
            end if;
            
            if state = 1 then
                cwout <= '1';
                ccwout <= '0';
            elsif state = 2 then
                ccwout <= '1';
                cwout <= '0';        
            else 
                ccwout <= '0';
                cwout <= '0';
            end if;
        
        end if;
        

    end process;

end arctop;