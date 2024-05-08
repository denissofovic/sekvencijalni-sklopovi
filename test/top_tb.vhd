library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OOK_Modulator_TB is
end entity;

architecture behavioral of OOK_Modulator_TB is
    component OOK_Modulator is
        port (
            oneh       : in unsigned(7 downto 0);
            onel       : in unsigned(7 downto 0);
            onesubper  : in unsigned(7 downto 0);
            zeroh      : in unsigned(7 downto 0);
            zerol      : in unsigned(7 downto 0);
            zerosubper : in unsigned(7 downto 0);
            sigval     : in unsigned(7 downto 0);
            mi         : in std_logic;
            mc         : out std_logic;
            fclk       : in std_logic;
            modulated  : out std_logic
        );
    end component;

    signal fclk         : std_logic := '0';
    signal oneh         : unsigned(7 downto 0) := to_unsigned(10, 8);
    signal onel         : unsigned(7 downto 0) := to_unsigned(20, 8);
    signal onesubper    : unsigned(7 downto 0) := to_unsigned(50, 8);
    signal zeroh        : unsigned(7 downto 0) := to_unsigned(5, 8);
    signal zerol        : unsigned(7 downto 0) := to_unsigned(15, 8);
    signal zerosubper   : unsigned(7 downto 0) := to_unsigned(100, 8);
    signal sigval       : unsigned(7 downto 0) := (others => '0');
    signal mi           : std_logic := '0';
    signal mc           : std_logic;
    signal modulated    : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: OOK_Modulator
    port map (
        oneh       => oneh,
        onel       => onel,
        onesubper  => onesubper,
        zeroh      => zeroh,
        zerol      => zerol,
        zerosubper => zerosubper,
        sigval     => sigval,
        mi         => mi,
        mc         => mc,
        fclk       => fclk,
        modulated  => modulated
    );

    clk_process: process
    begin
        while now < 1000 ns loop
            fclk <= '0';
            wait for CLK_PERIOD / 2;
            fclk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stimulus_process: process
    begin
        wait for CLK_PERIOD * 2;

        -- Inicijalizacija modulacije
        mi <= '1';

        -- Sekvenca bita za modulaciju
        sigval <= "10101010";
        wait for CLK_PERIOD * 8;

        -- Završetak modulacije
        mi <= '0';
        wait;

        -- Prikaz rezultata
        wait until mc = '1';
        report "Modulation complete!";
        wait;
    end process;

end architecture;