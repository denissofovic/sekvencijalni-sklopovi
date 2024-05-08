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
signal fclk: std_logic:='1';


begin
	counter: top port map (fclk=>fclk, cntout=>cntout);

	process
	
	begin
		assert false report "start simulation";
		fclk <= 'X';
		wait for 1 ns;
		
	
		for k in 0 to 17 loop
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














