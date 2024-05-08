library ieee;
use ieee.std_logic_1164.all;

entity top is
	Port (
		  BTN0: in std_logic;
		  BTN1: in std_logic;
		  BTN2: in std_logic;
	      LED0: out std_logic := '0';
	      LED1: out std_logic := '0';
	      LED2: out std_logic := '0';
	      YOUT: out std_logic := '0');
end top;

architecture arc_top of top is

begin
	LED0 <= BTN0;
	LED1 <= BTN1;
	LED2 <= BTN2;
	YOUT <= (BTN0 and BTN1) or ((not BTN1) and BTN2);
		
end arc_top;

