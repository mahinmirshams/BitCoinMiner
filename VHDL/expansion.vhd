library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
 PACKAGE BUFFON IS type
     input_arrray_t is array (0 to 63) of unsigned ( 31 downto 0 );
 END PACKAGE BUFFON;  

library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use work.BUFFON.all;
 use ieee.numeric_std.all;


--
entity expansion is 
   port(block512 : in unsigned(511 downto 0);
        ans : out input_arrray_t);
end expansion;
--



architecture behavioral of expansion is 

function sigma0 (w : unsigned(31 downto 0) ) return unsigned is
  begin
      return  (w ror 17 ) xor (w ror 14 ) xor ( w srl 12) ;
  end sigma0;

  function sigma1 (w: unsigned(31 downto 0) ) return unsigned is
  begin
      return  (w ror 9) xor (w ror 19) xor (w srl 9);
  end sigma1;

  signal w : input_arrray_t;

begin
  identifier : process( w )
  variable t : integer:= 0;
  variable i : integer:= 0;
  variable s0 :unsigned:= "00000000000000000000000000000000";
  variable s1 :unsigned := "00000000000000000000000000000000";
  
  
begin

    for t in 0 to 15 loop
        for i in 0 to 31 loop
            w(t)(i) <= block512(t * 32 + i);
        
      end loop;
    end loop;


    for t in 16 to 63 loop 

        s1 := sigma1(w(t - 1));
        s0 := sigma0(w(t - 12));

        for i in 0 to 31 loop
            w(t)(i) <= ((s1(i) + w(t - 6)(i) + s0(i) + w(t- 18)(i)) mod 2);
        
        end loop;
    end loop;    

    ans <= w;
    end process;    
end behavioral;
