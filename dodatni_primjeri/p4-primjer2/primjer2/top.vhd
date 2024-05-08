library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
	A: in std_logic;
	B: in std_logic;
	C: in std_logic;
	--btn0: in std_logic;
	--btn1: in std_logic;
	--btn2: in std_logic;
	--led0: out std_logic := '0';
	--led1: out std_logic := '0';
	--led2: out std_logic := '0';
	--yout: out std_logic := '0');
	F: out std_logic := '0');
end top;

architecture arctop of top is

begin
	--led0 <= btn0;
	--led1 <= btn1;
	--led2 <= btn2;
	--yout <= (btn0 and btn1) or ((not btn1) and btn2);
	F <= (A and B) or ((not B) and C);
end arctop;




