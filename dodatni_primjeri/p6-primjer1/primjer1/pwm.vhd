library ieee;
use ieee.std_logic_1164.all;


entity pwm is
port(
	fclk:		in std_logic; 
	duty:		in integer; 
	period:		in integer;
	pin:		out std_logic);  
end pwm;

architecture arch_pwm of pwm is
signal tmp: std_logic := '0';

begin
process(fclk)

variable cnt: integer:=0;
begin
    if fclk'event and fclk='1' then
		if cnt < duty then
			pin <= '1';
		elsif cnt < period then
			pin <= '0';
		else
			cnt:=0;
			pin <= '1';
		end if;
		cnt := cnt + 1;
   end if;
end process ;
end arch_pwm;



