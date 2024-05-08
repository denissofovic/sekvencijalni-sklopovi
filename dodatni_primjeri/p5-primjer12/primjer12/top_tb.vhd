library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top 
port(
	fclk:		in std_logic; 
    led:	out std_logic);  
end component;


signal fclk: std_logic:='0';
signal led: std_logic:='0';
signal endsim_main: std_logic:='0';
signal endsim_clk: std_logic:='0';
signal endsim: std_logic:='0';


begin
	mycomp: top port map (fclk=>fclk, led=>led);	
	endsim <= endsim_main or endsim_clk;

main: process
	
	begin
		report "start simulation";
		
		wait for 4000 ns;
		endsim_main <= '1';
			
		report "test completed";
		wait;
		
	end process;	


	
-- clk generation process for 500 MHz clock
clk:	process
		variable fclk_end: integer:= 5000; 		-- number of FPGA clock cycles
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





















