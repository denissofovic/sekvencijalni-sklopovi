library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    port (
        rgbin: in unsigned (23 downto 0);
        rgbout: out unsigned(15 downto 0) := x"0000"
    );
end top;


architecture arctop of top is


begin
    main:process(rgbin) 
    variable temp_rgbout: unsigned(15 downto 0) := x"0000";
    variable end_conv: std_logic := '0';
    variable j : integer := 23;
    begin
        for i in 15 downto 0 loop  
            if j = 18 then
                j:= 15;
            elsif j = 9 then
                j:= 7;    
            end if; 
            temp_rgbout(i) := rgbin(j);  
            j:= j - 1;  
        end loop;
        j := 23;
        rgbout <= temp_rgbout;

    end process;

end arctop;