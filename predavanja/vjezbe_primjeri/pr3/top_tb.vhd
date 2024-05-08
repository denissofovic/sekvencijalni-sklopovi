library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top 
	port (
        abc: in std_logic_vector(2 downto 0);
        Y: out std_logic_vector( 7 downto 0)
    );
end component;

signal abc: std_logic_vector (2 downto 0) := (others => '0');
signal Y: std_logic_vector (7 downto 0) := (others => '0');


begin
	dec: top port map (Y=>Y, abc=>abc);

	main: process
	begin
    abc <= "000";
    wait for 5 ns;
    abc <= "001";
    wait for 5 ns;
    abc <= "010";
    wait for 5 ns;
    abc <= "011";
    wait for 5 ns;
    abc <= "100";
    wait for 5 ns;
    abc <= "101";
    wait for 5 ns;
    abc <= "110";
    wait for 5 ns;
    abc <= "111";
    wait for 5 ns;
    wait;

	
	
	end process;
end arctop_tb;














