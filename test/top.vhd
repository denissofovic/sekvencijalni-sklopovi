library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OOK_Modulator is
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
end entity;

architecture behavioral of OOK_Modulator is
    signal current_bit   : unsigned(7 downto 0);
    signal modulating    : std_logic := '0';
    signal modulation_clk : unsigned(7 downto 0) := (others => '0');
    signal bit_index     : integer := 0;
    signal bit_count     : integer := 0;
    signal output_clk    : std_logic := '0';
    signal modulated_bit : std_logic := '0';

    begin
        process(fclk)
        begin
            if rising_edge(fclk) then
                if mi = '1' and modulating = '0' then
                    modulating <= '1';
                    bit_index <= 0;
                    bit_count <= 0;
                    modulation_clk <= (others => '0');
                end if;

                if modulating = '1' then
                    if bit_count < 8 then
                        current_bit <= sigval(bit_index);
                        bit_index <= bit_index + 1;
                        bit_count <= bit_count + 1;
                    else
                        modulating <= '0';
                        mc <= '1';
                    end if;
                end if;

                if modulating = '1'  then
                    if output_clk = '0' then
                        if current_bit = "1" then
                            output_clk <= '1';
                            modulation_clk <= onesubper - 1;
                            modulated_bit <= '1';
                        else
                            output_clk <= '1';
                            modulation_clk <= zerosubper - 1;
                            modulated_bit <= '0';
                        end if;
                    elsif modulation_clk = 0 then
                        output_clk <= '0';
                    else
                        modulation_clk <= modulation_clk - 1;
                    end if;
                end if;
            end if;
        end process;

        process(output_clk, modulated_bit)
        begin
            if output_clk = '1' then
                if modulated_bit = '1' then
                    modulated <= '1';
                else
                    modulated <= '0';
                end if;
            end if;
        end process;
end architecture;