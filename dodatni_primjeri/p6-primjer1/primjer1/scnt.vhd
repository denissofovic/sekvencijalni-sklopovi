library ieee;
use ieee.std_logic_1164.all;


entity scnt is
port(
	fclk:		in std_logic; 
	pin:		in std_logic; 
	bflag:		in std_logic; 
	eflag:		out std_logic;
	period:		out integer);  
end scnt;

architecture arch_scnt of scnt is

begin
process(fclk)

variable l_period: integer := 0;
variable state: integer := 0;

begin
	if fclk'event and fclk='1' then
		
		if state = 0 then
			if bflag = '1' then						-- initiate the measurement algo
				state := state + 1;
				l_period := 0;
				period <= 0;
				report "begin measurement";
			end if;
		elsif state = 1 then
			
			if pin = '1' then
				l_period := l_period + 1;
				
			else									-- measurement completed
				period <= l_period;
				eflag <= '1';
				state := state + 1;
				
				--report "measurement completed: " &integer'image(l_period);
			end if;	
		elsif state = 2 then
			if pin = '1' then
				eflag <= '0';
				l_period := 1;
				state := 1;
			end if;	
		end if;
		
		if bflag = '0' then
				report "period 0";
			period <= 0;
			state := 0;
		end if;
	end if;
end process ;
end arch_scnt;



