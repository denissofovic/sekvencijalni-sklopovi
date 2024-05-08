library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		  fclk: in std_logic;
	      led: out std_logic := '0');
end top;

architecture arc_top of top is
signal cnt:integer := 0;
signal led_state:std_logic := '0';
begin

blinky:	process (fclk) is
	begin
		if rising_edge(fclk) then
			cnt <= cnt + 1;
			if cnt >= 4 then
				if led_state = '0' then
					led <= '1';
					led_state <= '1';
				else
					led <= '0';
					led_state <= '0';
				end if;
				cnt <= 0;
			end if;
		end if;
	end process blinky;
end arc_top;

