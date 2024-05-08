library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top 
	port (cntout: out std_logic_vector (3 downto 0) := (others => '0');
		  fclk: in  std_logic);
end component;

signal cntout: std_logic_vector (3 downto 0) := (others => '0');
signal fclk: std_logic:='0';
signal endsim1: std_logic:='0';
signal endsim2: std_logic:='0';
signal endsim: std_logic:='0';


begin
	counter: top port map (fclk=>fclk, cntout=>cntout);	
	endsim <= endsim1 or endsim2;

main: process
	
	begin
		assert false report "start simulation";
		
		--wait for 34 ns;
		endsim1 <= '1';
			
		assert false report "test completed";
		wait;
		
	end process;


-- clk generation process for 500 MHz clock
clk:	process
		variable fclk_end: integer:= 100; 
		variable fclk_cnt: integer:= 0;
		
		begin
			fclk <= '1';
			wait for 1 ns;
			fclk <= '0';
			wait for 1 ns;
			
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














