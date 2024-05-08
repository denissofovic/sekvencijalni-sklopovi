library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		  fclk: in std_logic;
	      LED1: out std_logic := '0';
	      LED2: out std_logic := '0');
end top;

architecture arc_top of top is
signal cnt:integer := 0;
signal led_state1:std_logic := '0';
signal led_state2:std_logic := '0';
begin

blinky:	process (fclk) is
	
	begin
		if rising_edge(fclk) then
			cnt <= cnt + 1;
			if cnt = 25000000 then
				if led_state1 = '0' then
					LED1 <= '1';
					led_state1 <= '1';
				else
					LED1 <= '0';
					led_state1 <= '0';
				end if;
				cnt <= 0;
			end if;
			
			if cnt = 25000000 then
				if led_state2 = '0' then
					LED2 <= '1';
					led_state2 <= '1';
				else
					LED2 <= '0';
					led_state2 <= '0';
				end if;
			end if;
		end if;
	end process blinky;
end arc_top;

