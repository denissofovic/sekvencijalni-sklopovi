library ieee;
use ieee.std_logic_1164.all;


entity top is
port(
	clk:		in std_logic; 
	ctrl: 		out std_logic;
	btn:		in std_logic; 
    pwm_out:	out std_logic);  
end top;

architecture arch_top of top is
signal tmp: std_logic := '0';
begin
process(clk)
-- 50 MHz clock -> PWM pulses 1ms with 0-100 duty cycle (500 - 50000)

variable cnt: integer:=0;
variable duty: integer:=1;
variable dutycnt: integer:=0;

begin
    if clk'event and clk='1' then
		if cnt<duty then
			cnt:=cnt+1;
			pwm_out<='1';
		elsif cnt<20000 then
			cnt:=cnt+1;
			pwm_out<='0';
		else
			cnt:=0;
			pwm_out<='0';
			dutycnt := dutycnt + 1;
			
			if(dutycnt >= 1000) then
			   tmp <= tmp xor '1';
				ctrl <= tmp;
				
				dutycnt := 0;
				if btn = '0' then
					duty := duty*2;
				else
					duty := duty + 1400;
				end if;
				
				if(duty >= 20000) then
					duty := 10;
				end if;
			end if;
			
		end if;
   end if;
end process ;
end arch_top;



