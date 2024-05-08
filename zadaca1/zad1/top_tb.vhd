library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;


architecture arctop_tb of top_tb is
component top 
	port (
        adcval: in unsigned(7 downto 0) := (others => '0');
        thresh: in unsigned(7 downto 0) := (others => '0');
        result: out std_logic := '0';
        qi: in std_logic := '0';
        qc: out std_logic := '0';
		fclk: in  std_logic);
end component;

signal fclk: std_logic := '1';
signal adcval: unsigned(7 downto 0) := x"00";
signal thresh: unsigned(7 downto 0) := x"00";
signal result: std_logic:= '0';
signal qi: std_logic:= '0';
signal qc: std_logic:='0';


begin 
    quantisizer: top port map (fclk => fclk, adcval => adcval, thresh => thresh, result => result, qi => qi, qc => qc);

    process
    begin
		assert false report "start simulation";
		fclk <= '0';
        wait for 0.5 ns;

        adcval <= x"A5";
        thresh <= x"21";
        qi <= '1';
        fclk <= '1';
        wait for 0.5 ns;
        qi<='0';
        fclk <= '0';
        wait for 0.5 ns;
        adcval <= x"7F";
        thresh <= x"7F";
        qi <= '1';
        fclk <= '1';
        wait for 0.5 ns;
        qi<='0';
        fclk <= '0';
        wait for 0.5 ns;
        adcval <= x"3A";
        thresh <= x"5A";
        qi <= '1';
        fclk <= '1';
        wait for 0.5 ns;
        qi<='0';
        fclk <= '0';
        wait for 0.5 ns;
        fclk <= '0';
        assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;


