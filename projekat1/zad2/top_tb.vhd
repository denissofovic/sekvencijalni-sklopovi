library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;


architecture arctop_tb of top_tb is
component top 
	port (
        ina: in std_logic;
        inb: in std_logic;
        cwout: out std_logic := '0';
        ccwout: out std_logic:= '0';
        fclk: in std_logic
        );
end component;

signal ina: std_logic := '0';
signal inb: std_logic := '0';
signal cwout: std_logic := '0';
signal ccwout: std_logic:= '0';
signal fclk: std_logic := '0';



begin 
    main: top port map (fclk => fclk, ina => ina, inb => inb, cwout => cwout, ccwout => ccwout);

    process
    variable counter: integer := 0;
    variable period: integer := 20;
    variable period_counter_a: integer := 1;
    variable period_counter_b: integer := 1;
    variable offset_a: integer:= 10;
    variable offset_b: integer:= 15;
    variable state : std_logic := '0';
    
    begin
		assert false report "start simulation";
        
        
        for i in 0 to 205 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';

            counter := counter + 1;

            if counter = offset_a then   
                ina <= ina xor '1';   
            end if;

            if counter = offset_b then
                inb <= inb xor '1';        
            end if;

            if state = '0' then 

                if counter = (period/2) * period_counter_a then      
                    ina <= ina xor '1';       
                    period_counter_a:= period_counter_a + 1;        
                end if;
  
                if counter = (period/2) * period_counter_b + (offset_b - offset_a) then  
                    inb <= inb xor '1';       
                    period_counter_b:= period_counter_b + 1;
                end if;

            end if;


            if state = '1' then 

                if counter = (period/2) * period_counter_b then      
                    inb <= inb xor '1';       
                    period_counter_b:= period_counter_b + 1;        
                end if;
  
                if counter = (period/2) * period_counter_a + (offset_b - offset_a) then  
                    ina <= ina xor '1';       
                    period_counter_a:= period_counter_a + 1;
                end if;
                
            end if;

            if period_counter_b = 11 or period_counter_a = 17 or period_counter_b = 21 then
                state := state xor '1';
                ina <= '0';
                inb <= '0';
            end if;

        end loop;
        assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;


