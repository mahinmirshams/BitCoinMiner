library ieee;
library work;
use ieee.std_logic_1164.all;
use work.BUFFON2.all;



entity test_padding is
    end test_padding;
    
    architecture Behavioral of test_padding is


       
        
        
        component  padding
        generic(
            input_var : INTEGER := 24   
        );
        port
            (msg : in std_logic_vector((input_var-1) downto 0);
            length1 : in integer;
            ans : out padded_arrray_t);
        end component;
       
        signal   msg :  std_logic_vector(23 downto 0);
        signal   length1 :  integer;
        signal   ans : padded_arrray_t;



    begin
        Mypadding : padding 
        generic map (input_var => 24)
        port map (msg => msg ,length1 => length1 ,ans => ans);
        process
        begin
            msg <= "011000010110001001100011";
            length1 <= 24;
            wait for 30 ns;
        end process;
    
    end Behavioral;
