library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
 

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top is
	port (  
			fclk: in  std_logic; 	-- fpga clock pin
			toflag: out std_logic
	);		
end component;


signal fclk: std_logic:='1';
signal endsim1: std_logic:='0';
signal endsim2: std_logic:='0';
signal endsim: std_logic:='0';
signal toflag: std_logic;
signal g_fclk_cnt: integer:=0;


begin
	top_inst: top port map (fclk=>fclk, toflag=>toflag);	
	endsim <= endsim1 or endsim2;
	
	
-- main process	
main:	process
		variable state: integer:=0;
		
		begin
			wait for 1 ns;
			if state = 0 then
				if toflag = '1' then
					state := 1;
				end if;
				if (endsim = '1') then
					wait;
				end if;
			elsif state = 1 then
				if toflag = '0' then
					report "sim stop" ;
					endsim1 <= '1';
					wait;
				end if;
				if (endsim = '1') then
					wait;
				end if;
			end if;	
		end process;
	
-- clk generation process for 500 MHz clock
clk:	process
		variable fclk_end: integer:= 5000000; 
		variable fclk_cnt: integer:= 0;
		
		begin
			fclk <= '1';
			wait for 1 ns;
			fclk <= '0';
			wait for 1 ns;
			--g_fclk_cnt <= g_fclk_cnt + 1;
			
			fclk_cnt := fclk_cnt + 1;
			-- stop clk generation if the simulation process hangs
			if(fclk_cnt = fclk_end) then
				report "fpga clock exhausted";
				endsim2 <= '1';
				wait;
			end if;
			
			-- stop the clock generation if simulation process completed
			if(endsim = '1') then
				report "fpga clock shutdown";
				wait;
			end if;
				
		end process;	
	
end arctop_tb;














