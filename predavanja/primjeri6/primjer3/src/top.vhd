library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
	port (led: out std_logic := '0';
		  dtx: out std_logic;
		  fclk: in  std_logic);
end top;

architecture arctop of top is
signal data: unsigned (7 downto 0) := x"20";
signal tled: std_logic := '0';

begin
	process (fclk)
		variable state:integer:=0;
		variable pause:integer:=5000000;
		variable cnt:integer:=0;
		variable idx:integer:=0;
		
		variable baudrate:integer:=108;					--> 921600 Bauds -> 54 clocks of 50MHz 108->100MHz
		--variable baudrate:integer:=434;				--> 115200 Bauds -> 434 clocks of 50MHz 
		
		begin
			if fclk'event and fclk='1' then
				cnt := cnt + 1;
				if(state = 0) then						-- generate start bit
					if(cnt = pause) then				-- ? can we remove this and unify?
						cnt := 0;
						state := state + 1;
						pause := baudrate; 
						
						-- start bit
						dtx <= '0';
						tled <= tled  xor '1';
						led <= tled;
					end if;
				elsif(state <= 8) then					-- data
					if(cnt = pause) then
						cnt := 0;
						state := state + 1;
						pause := baudrate;
						
						-- data
						dtx <= data(idx);
						idx := idx + 1;
					end if;
				elsif(state = 9) then					-- stop bit
					if(cnt = pause) then
						cnt := 0;
						state := state + 1;
						pause := baudrate;
						
						-- stop bit
						dtx <= '1';
					end if;	
				else
					if(cnt = pause) then
						cnt := 0;
						state := 0;
						pause := 5000000;
						dtx <= '1';
						
						data <= data + x"01";
						if(to_integer(data) > 127) then
							data <= x"20";
						end if;
					end if;	
				end if;
			end if;
	end process;	

end arctop;



