library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;


architecture arctop_tb of top_tb is
component top 
	port (
        insig: in std_logic := '0';
        avrval: out unsigned(7 downto 0) := x"00";
		fclk: in  std_logic);
end component;

signal fclk: std_logic := '1';
signal insig: std_logic := '0';
signal avrval: unsigned(7 downto 0) := x"00";



begin 
    main_tb: top port map (fclk => fclk, insig => insig, avrval => avrval);
    process
    variable cnt:integer := 0;
    begin
        assert false report "start simulation";

        for k in 0 to 220 loop
            fclk <= '0';
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            cnt := cnt + 1;

            if cnt = 20 then
                insig <= '1';
            end if;

            if cnt = 40 then
                insig <= '0';
                
            end if;

            if cnt = 60 then
                insig <= '1';
            end if;

            if cnt = 120 then 
                insig <= '0';
            end if;
            

            if cnt = 130 then
                insig <= '1';
            end if;

            if cnt = 160 then
                insig <= '0';
            end if;


        end loop;
        cnt := 0;
        assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;


