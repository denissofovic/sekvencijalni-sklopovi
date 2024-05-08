library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is
component top 
    port(
    oneh : in unsigned(7 downto 0);
    onel : in unsigned(7 downto 0);
    onesubper : in unsigned(7 downto 0);
    zeroh : in unsigned(7 downto 0);
    zerol : in unsigned(7 downto 0);
    zerosubper : in unsigned(7 downto 0);
    mi : in std_logic;
    mc : out std_logic := '0';
    sigval : in std_logic_vector(7 downto 0);
    modsig : out std_logic:= '0';
    fclk: in std_logic
    );
end component;

signal oneh :  unsigned(7 downto 0) := x"00";
signal onel :  unsigned(7 downto 0) := x"00";
signal onesubper : unsigned(7 downto 0):= x"00";
signal zeroh : unsigned(7 downto 0):= x"00";
signal zerol : unsigned(7 downto 0):= x"00";
signal zerosubper :  unsigned(7 downto 0):= x"00";
signal mi : std_logic := '0';
signal mc : std_logic := '0';
signal sigval :  std_logic_vector(7 downto 0) := x"00";
signal modsig :  std_logic:= '0';
signal fclk: std_logic :='0';

begin 
    main: top port map(fclk => fclk, modsig => modsig, sigval => sigval, mc => mc, mi => mi, zerosubper => zerosubper, zerol => zerol, zeroh => zeroh, onesubper => onesubper, onel => onel, oneh => oneh);

    process
    begin
        assert false report "start simulation";
		fclk <= '0'; 
        oneh <= x"32";
        onel <= x"64";
        onesubper <= x"0A";
        zeroh <= x"1E";
        zerol <= x"5A";
        zerosubper <= x"0A";
        sigval <= x"DE"; 
        mi <= '1';
        for k in 0 to 1200 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        mi<='0';
        for k in 0 to 50 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        sigval <= x"AD";
        mi<='1';
        for k in 0 to 1200 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        mi<='0';

        for k in 0 to 50 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        sigval <= x"BE";
        mi<='1';
        for k in 0 to 1200 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        mi<='0';

        for k in 0 to 50 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        sigval <= x"EF";
        mi<='1';
        for k in 0 to 1200 loop
            wait for 0.5 ns;
            fclk <= '1';
            wait for 0.5 ns;
            fclk <= '0';
        end loop;
        mi<='0';
        assert false report "test completed";
		wait;
		
	end process;
end arctop_tb;