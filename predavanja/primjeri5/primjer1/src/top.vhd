library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		  fclk: in std_logic;
	      LED: out std_logic := '0');
end top;

architecture arc_top of top is

begin

blinky:	process (fclk) is
	variable cnt:integer := 0;
	variable led_state:bit := '0';
	begin
		if rising_edge(fclk) then
			cnt := cnt + 1;
			if cnt >= 25000000 then
				if led_state = '0' then
					LED <= '1';
					led_state := '1';
				else
					LED <= '0';
					led_state := '0';
				end if;
				
				cnt := 0;
			end if;
		end if;
	end process blinky;
		
end arc_top;

