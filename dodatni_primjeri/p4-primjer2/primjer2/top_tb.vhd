library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top 
	port (
	--btn0: in std_logic;
	--btn1: in std_logic;
	--btn2: in std_logic;
	--led0: out std_logic := '0';
	--led1: out std_logic := '0';
	--led2: out std_logic := '0';
	--yout: out std_logic := '0');
	A: in std_logic;
	B: in std_logic;
	C: in std_logic;
	F: out std_logic := '0');
end component;

signal A: std_logic:='0';
signal B: std_logic:='0';
signal C: std_logic:='0';
signal F: std_logic;

--signal btn0: std_logic:='0';
--signal btn1: std_logic:='0';
--signal btn2: std_logic:='0';
--signal led0: std_logic;
--signal led1: std_logic;
--signal led2: std_logic;
--signal yout: std_logic;


begin
	logfun: top port map (A=>A, B=>B, C=>C, F=>F);	

main: process
	
	begin
		report "start simulation";
		
		--btn0 <= '0';
		--btn1 <= '1';
		--wait for 100 ns;
		--btn0 <= '1';
		--wait for 100 ns;
		
		A <= '0';
		B <= '1';
		wait for 100 ns;
		A <= '1';
		wait for 100 ns;
			
		report "test completed";
		wait;
		
	end process;	
end arctop_tb;














