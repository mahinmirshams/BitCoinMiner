library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


 PACKAGE BUFFON2 IS type 
    padded_arrray_t is array (63 downto 0) of unsigned(511 downto 0) ;
 END PACKAGE BUFFON2; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BUFFON2.all;
use ieee.numeric_std.all;

--
entity padding is 
generic(
        input_var : unsigned := "11000" );
   port(
        msg : in unsigned((to_integer(input_var)-1) downto 0);
        length1 : in unsigned(to_integer(input_var) downto 0);
        ans : out padded_arrray_t);
end padding;
--



architecture behavioral of padding is 

signal message : unsigned(511 downto 0);

begin
  identifier : process( msg )
  variable blocknum : unsigned ;
  variable tmp : unsigned;
  variable k : unsigned;
  variable binaryNum : unsigned(63 downto 0);
  variable remainingLength :unsigned := unsigned(input_var);
  
  
begin
    blocknum := length1 / 512;
    blocknum := blocknum +1 ;
    tmp := length1 mod 512;

    for j in 0 to (to_integer(blocknum) - 2) loop
        ans(j) <= msg(to_integer(remainingLength) downto to_integer(remainingLength)-512);
        remainingLength := remainingLength - 512;
    end loop;

    message(511 downto 512 - to_integer(remainingLength)) <= msg(to_integer(remainingLength) downto 0); -- shak!
    message(511-to_integer(remainingLength)) <= '1'; -- shak!

    if tmp < 448 then
        k := 448 - tmp - 1;
    else 
        tmp := tmp - 448;
        k := tmp + 511;
    end if;

    for i in 0 to (to_integer(k)-1) loop
        message(511 - to_integer(remainingLength)-1-i) <= '0';
    end loop;

    binaryNum := remainingLength;

    message(63 downto 0) <= binaryNum(63 downto 0);

    ans(to_integer(blocknum)-1) <= message;

    end process;    
end behavioral;