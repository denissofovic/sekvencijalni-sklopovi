library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

    component top is
        port(
            data: in std_logic_vector(7 downto 0);
            par: out std_logic
        );
    end component;

    signal data: std_logic_vector(7 downto 0) := (others => '0');
    signal par: std_logic;

    begin
        
        
        
    parity: top PORT MAP (
            data => data,
            par => par
        );


    stim_proc: process
    
    
    begin
    wait for 5 ns;

    data <= "00011100"; --works fine for this one
    wait for 5 ns;

    data <= "10011100"; --4 '1's but par is '0'?
    wait for 5 ns;

    data <= "11011100"; --5 '1's but par is '1'?
    wait for 5 ns;

    data <= "00000001"; --??
    wait for 5 ns;
    
    --take a look at top.vhd, are we missing something?
    
    wait;

    
    end process;
    


end arctop_tb;