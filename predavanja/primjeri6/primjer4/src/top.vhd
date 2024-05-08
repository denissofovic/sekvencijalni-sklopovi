library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
	Port (  dtx : out std_logic;	-- uart tx pin	
			drx : in std_logic;		-- uart rx pin	
			led: out std_logic_vector (7 downto 0) := x"00";
			fclk: in  std_logic 	-- fpga clock pin
	);		
end top;

architecture arctop of top is
component uart
	port(   iclk: in std_logic;
			wdata: in unsigned (7 downto 0);
			rdata: out unsigned (7 downto 0);
			tx: out std_logic:='1';
			rx: in std_logic;
			wi: in std_logic;
			wc: out std_logic;
			rc: out std_logic);
end component;

signal urxstate: integer := 0;
signal utxstate: std_logic;
signal usize: unsigned (7 downto 0) := x"00";
signal uwdata: unsigned (7 downto 0) := x"00";
signal urdata: unsigned (7 downto 0) := x"00";
signal uwi: std_logic := '0';
signal uwc: std_logic;
signal urc: std_logic;


begin
	inst_uart: uart port map (iclk=>fclk, wdata=>uwdata, rdata=>urdata, tx=>dtx, rx=>drx, wi=>uwi, wc=>uwc, rc=>urc);
	
uart_rx: process
	begin
	if rising_edge(fclk) then
		if urxstate = 0 then
			if urc = '1' then
				led <= std_logic_vector(urdata);
				urxstate <= 1;
			end if;
		elsif urxstate = 1 then
			if urc = '0' then
				urxstate <= 0;
			end if;
		end if;
	end if;
end process;


end arctop;

