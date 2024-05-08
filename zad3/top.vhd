library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    port (
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
end top;


architecture arctop of top is
begin 
    main:process(fclk)
    variable idx:integer := 7;
    variable cnt: unsigned(7 downto 0) := x"00";
    variable cntl: unsigned(7 downto 0) := x"00";
    variable cnth: unsigned(7 downto 0) := x"00";
    variable cntsubper:unsigned(7 downto 0) := x"00";
    variable period: unsigned (7 downto 0) := x"00";
    variable h_flag : std_logic := '0';
    variable l_flag : std_logic := '0';
    variable mc_temp: std_logic := '0';
    variable next_bit_flag: std_logic := '0';
    variable temp_mod_signal: std_logic := '0';
    

   
    begin
        if falling_edge(fclk) then
            if falling_edge(mi) then
                mc_temp := '1';
                next_bit_flag := '1';
                cnth := x"00";
                cntl := x"00";
                cnt := x"00";
                cntsubper := x"00";
                period := x"00";
                h_flag := '0';
                l_flag := '0';
                temp_mod_signal := '0';
            end if;

            if rising_edge(mi) then
                mc_temp := '0';
            end if;

            mc <= mc_temp; 
            
            if mi = '1' or mc_temp = '0' then 
                
                if sigval(idx) = '1' then 
                    
                    next_bit_flag := '0';
                    cnt := cnt + 1;
                    if cnt < (onel + oneh)  then    
                        if cntl < onel then
                            modsig <= '0';
                            cntl := cntl + 1;
                        else 
                            h_flag := '1';
                        end if; 
                        
                        if h_flag = '1' then
                            if cnth <  oneh then

                                if cntsubper = ((onesubper/2) * period) then
                                    modsig <= temp_mod_signal xor '1';
                                    temp_mod_signal:= temp_mod_signal xor '1';
                                    period := period + 1;
                                end if;
                                
                                cntsubper := cntsubper + 1;
                                cnth := cnth + 1;
                            end if;                
                        end if; 
                        
                    
                    else
                        next_bit_flag := '1';
                        cnth := x"00";
                        cntl := x"00";
                        cnt := x"00";
                        cntsubper := x"00";
                        period := x"00";
                        h_flag := '0';
                        l_flag := '0';
                        temp_mod_signal := '0';
                    end if; 
                    
                end if; 


                if sigval(idx) = '0' then 
                    next_bit_flag := '0';
                    cnt := cnt + 1;
                    if cnt < (zerol + zeroh) then    
                        if cnth < zeroh then
                            if cntsubper = ((zerosubper/2) * period) then
                                modsig <= not (temp_mod_signal xor '1');
                                temp_mod_signal:= temp_mod_signal xor '1';
                                period := period + 1;
                            end if;
                            
                            cntsubper := cntsubper + 1;
                            cnth := cnth + 1;
                            
                        else 
                            l_flag := '1';
                        end if; 
                        
                        if l_flag = '1' then
                            if cntl <  zerol then
                           
                                modsig <= '0';
                                cntl := cntl + 1;
                                
                            end if;                 

                        end if; 
                        
                    
                    else
                        next_bit_flag := '1';
                        cnth := x"00";
                        cntl := x"00";
                        cnt := x"00";
                        cntsubper := x"00";
                        period := x"00";
                        h_flag := '0';
                        l_flag := '0';
                        temp_mod_signal := '0';
                    end if; 
                    
                end if;                                 

                if next_bit_flag = '1' then
                    idx := idx - 1; 
                end if; 

                if idx < 0 then
                    mc_temp := '1';   
                end if;
                
            end if;   

            if mc_temp = '1' then
                idx := 7;
                modsig <= '0';
            end if;           
        end if;   
    end process;
end arctop; 