library ieee;
use ieee.std_logic_1164.all;

entity top is
    port(
        data: in std_logic_vector(7 downto 0);
        par: out std_logic := '0'
    );
end top;

architecture arctop of top is
    begin

      
        main: process(data)
        variable tpar: std_logic := '0';
        begin
       

        for k in 0 to 7 loop
            tpar := data(k) XOR tpar; --would it work if tpar is a signal?
        end loop;

        
        
        par <= NOT tpar;
        

        end process;

    end arctop;