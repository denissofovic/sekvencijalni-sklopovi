library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

    component top is
      port (
            fclk: in std_logic;
            a, b: in unsigned (3 downto 0) := (others => '0');
            out1: out unsigned (3 downto 0) := (others => '0');
            carry: out std_logic := '0'
        );
    end component;


signal fclk: std_logic:='1';
signal a: unsigned (3 downto 0);
signal b: unsigned (3 downto 0);
signal out1: unsigned (3 downto 0);
signal carry: std_logic;


begin
	counter: top port map (fclk=>fclk, a=>a, b=>b, out1 => out1, carry => carry );

	clk: process
	
	begin
		assert false report "start simulation";
		fclk <= 'X';
		wait for 1 ns;
		
	
		for k in 0 to 20 loop
			fclk <= '0';
			wait for 1 ns;
			
			fclk <= '1';
			wait for 1 ns;	
		end loop;
			
		assert false report "test completed";
		wait;
		
	end process;

    adder: process
    begin
        wait for 2 ns;
        a <= x"4";
        b <= x"1";

        wait for 5 ns;
        a <= x"B";
        b <= x"9";

        wait for 5 ns;
        a <= x"B";
        b <= x"F";

        wait for 5 ns;
        a <= x"8";
        b <= x"7";

        wait;


    end process;

end arctop_tb;