library ieee;
use ieee.std_logic_1164.all;
 PACKAGE BUFFON2 IS type padded_arrray_t is array (63 downto 0) of std_logic_vector(511 downto 0) ;
 END PACKAGE BUFFON2; 

 library ieee;
use ieee.std_logic_1164.all;
use work.BUFFON2.all;



entity test_padding is
    end test_padding;
    
    architecture Behavioral of test_padding is


       
        
        
        component  padding
        generic(
            input_var : INTEGER := 24);   
        );
        port
            (msg : in std_logic_vector((input_var-1) downto 0);
            length : in std_logic;
            ans : out padded_arrray_t);
        end component;
       
        signal   msg :  std_logic_Vector(23 downto 0);
        signal   length :  std_logic;
        signal   ans : padded_array_t);



    begin
        Mypadding : pading 
        generic map (input_var => 24);
        port map (msg => msg ,length => length ,ans => ans);
        process
        begin
            msg <= "011000010110001001100011";
            length <= "11000";
            wait for 30 ns;
        end process;
    
    end Behavioral;
