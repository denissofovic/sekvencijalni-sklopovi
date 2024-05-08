library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
	port (led: out std_logic := '0';
		  btn: in std_logic;
		  fclk: in  std_logic);
end top;

architecture arctop of top is

begin
	process (fclk)
		variable dflag:integer:=0;							-- debouncing active
		variable btnval:integer:=0;							-- button state
		variable cnt:integer:=0;							-- time tick counter
		
		begin
			if rising_edge(fclk) then
				if(btn = '0') then
					if(dflag = 0) then
						dflag := 1;
						cnt :=0;
															-- Q: how to improve the next 7 lines
						--led <= led xor '1';				-- Q: can we replace everthing below?
															
						if(btnval = 0) then
							led <= '1';
							btnval := 1;
						else
							led <= '0';
							btnval := 0;
						end if;
					else 
						cnt:=0;
					end if;
				else
					if(dflag = 1) then
						cnt := cnt + 1;
						if(cnt > 250000) then				-- debounce for 50 ms
							dflag := 0;
						end if;
					end if;	
				end if;
			end if;
	end process;
end arctop;



