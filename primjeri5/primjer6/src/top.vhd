library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		  fclk: in std_logic;
		  BTN: in std_logic;
	      LED1: out std_logic := '0';
	      LED2: out std_logic := '0');
end top;

architecture arc_top of top is

begin

blinky:	process (fclk) is
	variable cnt:integer := 0;
	variable led_state:bit := '0';
	begin
		if rising_edge(fclk) then
			cnt := cnt + 1;
			if cnt >= 100000000 then
				if led_state = '0' then
					LED1 <= '1';
					led_state := '1';
				else
					LED1 <= '0';
					led_state := '0';
				end if;
				cnt := 0;
			end if;
		end if;
	end process blinky;


button:	process (fclk) is
	begin
		if rising_edge(fclk) then
			if (BTN = '0') then
				LED2 <= '1';
			else	
				LED2 <= '0';
			end if;
		end if;
	end process button;	
	
		
end arc_top;

