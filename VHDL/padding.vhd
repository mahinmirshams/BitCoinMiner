library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.BUFFON2.all;
use ieee.numeric_std.all;

--
entity padding is 
generic(
        input_var : integer := 1 );
   port(
        msg : in std_logic_vector(input_var-1 downto 0);
        length1 : in integer;
        ans : out padded_arrray_t);
end padding;
--



architecture behavioral of padding is 

signal message : std_logic_vector(511 downto 0);

begin
  identifier : process( msg )
  
  variable k : integer := 0;
   

  variable tmp : integer := 0;
  variable blocknum : integer := 0 ;
  
  variable binaryNum : integer;
  variable remainingLength :integer := input_var;
  
  
begin
    blocknum := length1/ 512 + 1;
    blocknum := blocknum +1 ;
    tmp := length1 mod 512;
    
    blocknum := blocknum-2;
    ans(0) <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000010110001001100011";
    for j in 0 to blocknum loop
        ans(j) <= msg(remainingLength downto remainingLength -512);
        remainingLength := remainingLength - 512;
    end loop;

    message(511 downto 512 - remainingLength) <= msg(remainingLength downto 0); -- shak!
    message(511-remainingLength) <= '1'; -- shak!

    if tmp < 448 then
        k := 448 - tmp - 1;
    else 
        tmp := tmp - 448;
        k := tmp + 511;
    end if;

    for i in 0 to (k-1) loop
        message(511 - remainingLength-1-i) <= '0';
    end loop;

    binaryNum := remainingLength;

    message(63 downto 0) <= std_logic_vector(to_unsigned(binaryNum, 64));

    ans(blocknum-1) <= message;

    end process;    
end behavioral;