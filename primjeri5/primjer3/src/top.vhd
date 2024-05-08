library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		  fclk: in std_logic;
	      LED: out std_logic := '0');
end top;

architecture arc_top of top is
signal led_state:std_logic := '0';
begin

blinky:	process (fclk) is
	variable cnt:integer := 0;
	begin
		if rising_edge(fclk) then
			cnt := cnt + 1;
			if cnt >= 25000000 then
				led_state <= led_state xor '1';
				LED <= led_state;
				cnt := 0;
			end if;
		end if;
	end process blinky;
		
end arc_top;

