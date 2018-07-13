library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;

entity test_sha is
    end test_sha;
    
    architecture Behavioral of test_sha is


     
        component sha256 is generic(input_var : integer := 24);
        Port (
              input_sha : in std_logic_vector(input_var-1 downto 0);
              output_sha : out std_logic_vector(255 downto 0)
         );
        end component;
       
        signal   input_sha :  std_logic_vector(23 downto 0);
        signal   output_sha : std_logic_vector(255 downto 0);



    begin
        Mysha : sha256 
        generic map (input_var => 24)
        port map (input_sha, output_sha);
        process
        begin
            input_sha <= "011000010110001001100011";
         
            wait for 30 ns;
        end process;
    
    end Behavioral;
