library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
	port (ledr: out std_logic := '0';
		  ledg: out std_logic := '0';
		  ledb: out std_logic := '0';
		  fclk: in  std_logic);
end top;

architecture arctop of top is

component pwm
	port( 
	ipin:  out std_logic := '0';
	iclk: in std_logic;
	iduty: in unsigned (31 downto 0) := x"00000000";
	ifreq: in unsigned (31 downto 0) := x"00000000");
end component;


signal freq:unsigned (31 downto 0) := x"0000C800";			-- 51200 = 1024*50 -> 1.024ms	
signal dutystep:unsigned (31 downto 0) := x"00000032";		-- 50 -> 10 levels of PWM
signal rduty:unsigned (31 downto 0) := x"00000000";	
signal gduty:unsigned (31 downto 0) := x"00000000";
signal bduty:unsigned (31 downto 0) := x"00000000";

begin
	-- instanciranje komponenti
	pwmr: pwm port map (ipin=>ledr, iclk=>fclk, iduty=>rduty, ifreq=>freq);
	pwmg: pwm port map (ipin=>ledg, iclk=>fclk, iduty=>gduty, ifreq=>freq);
	pwmb: pwm port map (ipin=>ledb, iclk=>fclk, iduty=>bduty, ifreq=>freq);
	process
	
	variable cntcolor:integer:=0;
	variable cntstep:integer:=0;
	variable state:integer:=0;
	variable substate:integer:=0;
	
	begin
		if fclk'event and fclk='1' then
			
			cntcolor := cntcolor + 1;
			if(cntcolor >= 200000000) then
				cntcolor := 0;
				state := state + 1;
				if(state = 6) then
					state := 0;
				end if;
				cntstep := 0;
				substate := 0;
			else
				cntstep := cntstep + 1;
			end if;
			
			if state = 0 then
				if(substate = 0) then
					substate := 1;
					rduty <= x"0000C800";
					gduty <= dutystep;
					bduty <= x"00000000";
				else
					if cntstep >= 20000000 then		
						gduty <= gduty + gduty;			-- Q: whate if we use multiplication here?
						cntstep := 0;
					end if;
				end if;	
				
			elsif state = 1 then
				if(substate = 0) then
					substate := 1;
					rduty <= x"0000C800";
					gduty <= x"0000C800";
					bduty <= x"00000000";
				else
					if cntstep >= 20000000 then
						rduty <= shift_right(rduty,1);	-- Q: is it same as /2?
						cntstep := 0;
					end if;
				end if;	
				
			elsif state = 2 then
				if(substate = 0) then
					substate := 1;
					rduty <= x"00000000";
					gduty <= x"0000C800";
					bduty <= dutystep;
				else
					if cntstep >= 20000000 then
						bduty <= shift_left(bduty,1);	-- Q: is it same as *2?
						cntstep := 0;
					end if;
				end if;
			
			elsif state = 3 then
				if(substate = 0) then
					substate := 1;
					rduty <= x"00000000";
					gduty <= x"0000C800";
					bduty <= x"0000C800";
				else
					if cntstep >= 20000000 then
						gduty <= gduty/2;
						cntstep := 0;
					end if;
				end if;
				
			elsif state = 4 then
				if(substate = 0) then
					substate := 1;
					rduty <= dutystep;
					gduty <= x"00000000";
					bduty <= x"0000C800";
				else
					if cntstep >= 20000000 then
						rduty <= rduty + rduty;
						cntstep := 0;
					end if;
				end if;
				
			elsif state = 5 then
				if(substate = 0) then
					substate := 1;
					rduty <= x"0000C800";
					gduty <= x"00000000";
					bduty <= x"0000C800";
				else
					if cntstep >= 20000000 then
						bduty <= bduty/2;
						cntstep := 0;
					end if;
				end if;
				
			end if;
	
			
	    end if;
	end process;
end arctop;



