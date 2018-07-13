library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.BUFFON2.all;



entity test_padding is
    end test_padding;
    
    architecture Behavioral of test_padding is


       
        
        
        component  padding
        generic(
            input_var : INTEGER := 104   
        );
        port
            (msg : in unsigned((input_var-1) downto 0);
           
          res : out unsigned(512 downto 0));
        end component;
       
        signal   msg :  unsigned(103 downto 0);
      
        signal   res : unsigned(512 downto 0);



    begin
        Mypadding : padding 
        generic map (input_var => 104)
        port map (msg => msg ,res => res);
        process
        begin
            msg <= "01001010011000010111011001100001011001000010000001010100011000010110110001100001011001100111100100001010";
            wait for 30 ns;
        end process;
    
    end Behavioral;
