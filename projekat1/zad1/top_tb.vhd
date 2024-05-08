library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;


architecture arctop_tb of top_tb is
component top 
	port (
        rgbin: in unsigned (23 downto 0);
        rgbout: out unsigned(15 downto 0) := x"0000"
        );
end component;


signal rgbin: unsigned(23 downto 0) := x"000000";
signal rgbout: unsigned(15 downto 0) := x"0000";

begin 
    main: top port map (rgbin => rgbin, rgbout => rgbout);

    process
    
    begin
		assert false report "start simulation";
		wait for 20 ns;
        rgbin <= x"202306";
        wait for 20 ns;
        rgbin <= x"ADBEEF";
        wait for 20 ns;
        rgbin <= x"123456";
        wait for 20 ns;

        assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;


