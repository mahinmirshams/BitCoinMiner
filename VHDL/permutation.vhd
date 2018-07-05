library ieee;
use ieee.std_logic_1164.all;
--PACKAGE BUFFON1 IS type input_arrray_t is array (31 downto 0) of INTEGER range 0 to 15 ;
 --END PACKAGE BUFFON1; 
 PACKAGE BUFFON IS type input_arrray_t is array (63 downto 0) of INTEGER range 0 to 31 ;
 END PACKAGE BUFFON; 

--
entity permutation is 
   port(block : in BUFFON;
        ans : out BUFFON);
end permutation;
--



architecture behavioral of permutation is 

function sigma0 (w,res : unsigned(31 downto 0)) return unsigned is
    variable r1: unsigned(31 downto 0);
    variable r2: unsigned(31 downto 0);
    variable s0: unsigned(31 downto 0);
    variable tmp: unsigned(31 downto 0);
    
  begin
      r1 <= w ror 17;
      r2 <= w ror 14;
      s0 <= w srl 12;
      tmp <= r1 xor r2;
      res <= tmp xor s0;
    
  end sigma0;

  function sigma1 (w,res : unsigned(31 downto 0) ) return unsigned is
    variable r1: unsigned(31 downto 0);
    variable r2: unsigned(31 downto 0);
    variable s0: unsigned(31 downto 0);
    variable tmp: unsigned(31 downto 0);
    
  begin
      r1 <= w ror 9;
      r2 <= w ror 19;
      s0 <= w srl 9;
      tmp <= r1 xor r2;
      res <= tmp xor s0;
    
  end sigma1;


begin
  identifier : process( w )
  begin
      variable i := '0';
      variable temp := '0';
      
      process (A)
begin

    for t in 0 to 31 loop
        temp = w(31 - i);
        w(31 - i) = w(i);
        w(i) = temp;
    end loop;


    

        for i in 0 to 7 loop
            temp = w(8 + i);
        w(16 + i) = w(15 - i);
        w(15 - i) = temp;
        
    end loop;    
    end process;    
end behavioral;