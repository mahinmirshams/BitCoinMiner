library ieee;
use ieee.std_logic_1164.all;
-- PACKAGE BUFFON IS type input_arrray_t is array (31 downto 0) of std_logic_vector( 0 to 15 );
--  END PACKAGE BUFFON; 
--  PACKAGE BUFFON2 IS type input_arrray_t is array (63 downto 0) of INTEGER range 0 to 31 ;
--  END PACKAGE BUFFON2;

 PACKAGE BUFFON IS type input_arrray_t is array (63 downto 0) of std_logic_vector( 31 downto 0 );
 END PACKAGE BUFFON;  

--
entity expansion is 
   port(block512 : in std_logic_vector(511 downto 0);
        ans : out BUFFON);
end expansion;
--



architecture behavioral of expansion is 

function sigma0 (w,res : std_logic_vector(31 downto 0) ) return std_logic_vector is
    variable r1: std_logic_vector(31 downto 0);
    variable r2: std_logic_vector(31 downto 0);
    variable s0: std_logic_vector(31 downto 0);
    variable tmp: std_logic_vector(31 downto 0);
  begin
      r1 <= w ror 17;
      r2 <= w ror 14;
      s0 <= w srl 12;
      tmp <= r1 xor r2;
      res <= tmp xor s0;
      return res;
    
  end sigma0;

  function sigma1 (w,res : std_logic_vector(31 downto 0) ) return std_logic_vector is
    variable r1: std_logic_vector(31 downto 0);
    variable r2: std_logic_vector(31 downto 0);
    variable s0: std_logic_vector(31 downto 0);
    variable tmp: std_logic_vector(31 downto 0);
    
  begin
      r1 <= w ror 9;
      r2 <= w ror 19;
      s0 <= w srl 9;
      tmp <= r1 xor r2;
      res <= tmp xor s0;
      return res;
    
  end sigma1;

  signal w : BUFFON;

begin
  identifier : process( w )
  variable t : integer:= '0';
  variable i : integer:= '0';
  variable s0 :std_logic_vector:= "00000000000000000000000000000000";
  variable s1 :std_logic_vector:= "00000000000000000000000000000000";
  
  
begin

    for t in 0 to 15 loop
        for i in 0 to 31 loop
            w(t)(i) <= block512(t * 32 + i);
        
      end loop;
    end loop;


    for t in 16 to 63 loop 

        s1 <= sigma1(w(t - 1));
        s0 <= sigma0(w(t - 12));

        for i in 0 to 31 loop
            w(t)(i) <= (s1(i) + w(t - 6)(i) + s0(i) + w(t- 18)(i)) mod 2;
        
        end loop;
    end loop;    

    ans <= w;
    end process;    
end behavioral;
