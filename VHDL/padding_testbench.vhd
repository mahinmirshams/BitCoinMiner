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


        signal   msg :  std_logic_Vector(7 downto 0);
        signal   length :  std_logic_vector (2 downto 0);
        signal   ans :  std_logic_vector (7 downto 0);


        
        
        component  pasding
        generic(
            input_var : INTEGER := 24);   
        );
        port
            (msg : in std_logic_vector((input_var-1) downto 0);
            length : in std_logic;
            ans : out BUFFON2);
        end component;
       


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