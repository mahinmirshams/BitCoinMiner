library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;

entity test_sha is
    end test_sha;
    
    architecture Behavioral of test_sha is


<<<<<<< HEAD
     
=======
       
        
        
>>>>>>> eaddf5be7f4dc56a2e86607bd169148e4590c6ec
        component sha256 is generic(input_var : integer := 24);
        Port (
              input_sha : in std_logic_vector(input_var-1 downto 0);
              output_sha : out std_logic_vector(255 downto 0)
         );
        end component;
       
<<<<<<< HEAD
        signal   input_sha :  std_logic_vector(23 downto 0);
=======
        signal   input_sha :  std_logic_vector(input_var downto 0);
>>>>>>> eaddf5be7f4dc56a2e86607bd169148e4590c6ec
        signal   output_sha : std_logic_vector(255 downto 0);



    begin
<<<<<<< HEAD
        Mysha : sha256 
=======
        Mysha : sha 
>>>>>>> eaddf5be7f4dc56a2e86607bd169148e4590c6ec
        generic map (input_var => 24)
        port map (input_sha, output_sha);
        process
        begin
<<<<<<< HEAD
            input_sha <= "011000010110001001100011";
=======
            msg <= "011000010110001001100011";
>>>>>>> eaddf5be7f4dc56a2e86607bd169148e4590c6ec
         
            wait for 30 ns;
        end process;
    
    end Behavioral;
