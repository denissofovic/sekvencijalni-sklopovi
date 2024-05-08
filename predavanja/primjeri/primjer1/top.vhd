library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
	port (cntout: out std_logic_vector (3 downto 0) := (others => 'L');
		  fclk: in  std_logic);
end top;

architecture arctop of top is

signal cnt_state:unsigned (3 downto 0) := x"0";

begin
	process (fclk)											-- must have sensitivity list for simulation!
		
	begin
		if fclk'event and fclk='1' then
			
			cnt_state <= cnt_state + 1;
			cntout <= std_logic_vector(cnt_state);
			
			if(cnt_state > 15) then
				cnt_state <= x"0";
			end if;
	    end if;
	end process;
end arctop;



