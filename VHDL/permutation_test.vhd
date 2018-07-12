library ieee;
use ieee.std_logic_1164.all;
use work.BUFFON.all;



entity test_permutation is
    end test_permutation;
    
    architecture Behavioral of test_permutation is


       
        
        
        component permutation
    port(
        block64_32 : in input_arrray_t;
        ans : out input_arrray_t);
    end component;
       
    signal  block64_32 :  input_arrray_t;
    signal ans :  input_arrray_t;


    begin
        permutation1: permutation
        port map (block64_32 => block64_32, ans=>ans);
    
        process
        begin
            block64_32(0) <="00000000000000000000000000000011" ;
           for i in 0 to 63 loop
              block64_32(i) <="00000000000000000000000000000000" ;
            end loop;
            wait for 30 ns;
        end process;
    
    end Behavioral;