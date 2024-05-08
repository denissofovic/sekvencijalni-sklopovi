library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component pwm 
port(
	fclk:		in std_logic; 
	duty:		in integer; 
	period:		in integer;
	pin:		out std_logic); 
end component;

component scnt 
port(
	fclk:		in std_logic; 
	pin:		in std_logic; 
	bflag:		in std_logic; 
	eflag:		out std_logic;
	period:		out integer); 
end component;


signal endsim_main: std_logic:='0';
signal endsim_clk: std_logic:='0';
signal endsim: std_logic:='0';

signal fclk: std_logic:='0';
signal led: std_logic:='0';
signal duty: integer := 50;
signal period: integer := 100;		-- signal with target period

signal bflag: std_logic:='0';
signal eflag: std_logic:='0';
signal mperiod: integer := 0;		-- signal holding result of measurement


begin
	c_pwm: pwm port map (fclk=>fclk, pin=>led , duty=>duty, period=>period);	
	c_scnt: scnt port map (fclk=>fclk, pin=>led , bflag=>bflag, eflag=>eflag, period=>mperiod);	
	endsim <= endsim_main or endsim_clk;

main: process
	variable state: integer:= 0;
	variable l_duty: integer:= 10;
	begin
		
		report "start simulation";
		duty <= 10;
		period <= 100;
		
		wait for 1000 ns;
		endsim_main <= '1';
		
		report "test completed";
		wait;
		
		--if state = 0 then
			--report "start simulation";
			---- set target parameters for the source
			--duty <= 10;
			--period <= 100;
			--state := state + 1;
			--bflag <= '1';
		--elsif state = 1 then
			--if eflag = '1' then
				--state := state + 1;
			--end if;
		--elsif state = 2 then
			--if eflag = '0' then
				--l_duty := l_duty*2;
				--if(l_duty >= 100) then
					--report "test completed";
					--endsim_main <= '1';
					--wait;
				--else
					--report "measurement done: " &integer'image(mperiod);
					--duty <= l_duty;
					--state := 1;
				--end if;
			--end if;
		--end if;
		
		wait for 1 ns;
	end process;	


	
-- clk generation process for 500 MHz clock
clk:	process
		variable fclk_end: integer:= 50000; 		-- number of FPGA clock cycles
		variable fclk_cnt: integer:=0;
		
		begin
			fclk <= '1';
			wait for 1 ns;
			fclk <= '0';
			wait for 1 ns;
			
			
			fclk_cnt := fclk_cnt + 1;
			-- stop clk generation if the simulation process hangs
			if(fclk_cnt = fclk_end) then
				report "fpga clock exhausted";
				endsim_clk <= '1';
				wait;
			end if;
			
			-- stop the clock generation if simulation process completed
			if(endsim = '1') then
				report "fpga clock shutdown";
				wait;
			end if;
				
		end process;	
end arctop_tb;





















