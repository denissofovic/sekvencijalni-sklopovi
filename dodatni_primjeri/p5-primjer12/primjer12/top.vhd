library ieee;
use ieee.std_logic_1164.all;


entity top is
port(
	fclk:		in std_logic; 
	led:		out std_logic);  
end top;

architecture arch_top of top is
signal tmp: std_logic := '0';

begin
process(fclk)

variable cnt: integer:=0;
variable duty: integer:=1;
variable dutycnt: integer:=0;
variable flag: integer := 0;
begin
    if fclk'event and fclk='1' then
		if cnt = 0 then
			tmp <= '1';
		else
			tmp <= '0';
		end if;
			
		if cnt<duty then
			cnt:=cnt+1;
			led<='1';
			
		elsif cnt<100 then
			cnt:=cnt+1;
			led<='0';
			
			
		else
			cnt:=0;
			led<='0';
			dutycnt := dutycnt + 1;
			
			if(dutycnt >= 1) then
				
				dutycnt := 0;
				duty := duty*2;
				
				if(duty >= 100) then
					duty := 1;
				end if;
			end if;
			
		end if;
  
   end if;
end process ;
end arch_top;



