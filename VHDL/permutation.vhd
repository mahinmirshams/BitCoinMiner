library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

--PACKAGE BUFFON1 IS type input_arrray_t is array (31 downto 0) of INTEGER range 0 to 15 ;
 --END PACKAGE BUFFON1; 
--  PACKAGE BUFFON IS type input_arrray_t is array (63 downto 0) of INTEGER range 0 to 31 ;
--  END PACKAGE BUFFON; 
 PACKAGE BUFFON IS type 
 input_arrray_t is array (63 downto 0) of std_logic_vector( 31 downto 0 );
 END PACKAGE BUFFON;  
 
 library ieee;
 use IEEE.STD_LOGIC_1164.all;
 use IEEE.NUMERIC_STD.all;
 use IEEE.STD_LOGIC_ARITH.all;
 use IEEE.STD_LOGIC_UNSIGNED.all;
 use work.BUFFON.all;

--
entity permutation is 
   port(block64_32 : in input_arrray_t;
        ans : out input_arrray_t);
end permutation;
--

architecture behavioral of permutation is 
signal w : input_arrray_t;

begin
  identifier : process( w )
  variable i :integer := '0';
  variable temp : integer := '0';
  
begin

    for t in 0 to 31 loop
        temp <= w(31 - i);
        w(31 - i) <= w(i);
        w(i) <= temp;
    end loop;

    for i in 0 to 7 loop
        temp <= w(8 + i);
        w(16 + i) <= w(15 - i);
        w(15 - i) <= temp;
    end loop;    

    ans <= w;

    end process;    
end behavioral;
