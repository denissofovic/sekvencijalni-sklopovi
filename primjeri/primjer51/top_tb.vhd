library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top
	port (
		  fclk: in std_logic;
	      LED: out std_logic := '0');
end component;

signal fclk: std_logic:='1';
signal LED: std_logic:='0';

begin
	counter: top port map (fclk=>fclk, LED=>LED);

	process
	
	begin
		assert false report "start simulation";
		fclk <= 'X';
		wait for 1 ns;
		
	
		for k in 0 to 117 loop
			fclk <= '0';
			wait for 1 ns;
			
			fclk <= '1';
			wait for 1 ns;	
		end loop;

		
		--fclk <= '0';
		--wait for 1 ns;
		
		--fclk <= '1';
		--wait for 1 ns;
		
		--fclk <= '0';
		--wait for 1 ns;
		
		--fclk <= '1';
		--wait for 1 ns;
			
		assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;














