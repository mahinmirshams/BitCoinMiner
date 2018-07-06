library ieee;
use ieee.std_logic_1164.all;
 PACKAGE BUFFON2 IS type padded_arrray_t is array (63 downto 0) of std_logic_vector(511 downto 0) ;
 END PACKAGE BUFFON2; 

--
entity padding is 
generic(
        input_var : INTEGER   
    );
   port(msg : in std_logic_vector((input_var-1) downto 0);
        length : in std_logic;
        ans : out padded_arrray_t;
end padding;
--



architecture behavioral of padding is 

signal message : std_logic_vector(511 downto 0)

begin
  identifier : process( ans )
  variable blocknum : integer:= length / 512 + 1;
  variable tmp : integer:= length mod 512;
  variable binaryNum : std_logic_vector(63 downto 0);
  variable k :std_logic =: 0;
  variable i :std_logic =: 0;
  variable j :std_logic =: 0;
  variable x :std_logic =: 0;
  variable remainingLength :integer =: input_var;
  
  
begin

    for j in 0 to (blocknum - 2) loop
        ans(j) <= msg(remainingLength downto remainingLength-512);
        remainingLength = remainingLength - 512;
    end loop;

    message(511 downto 512-remainingLength) <= msg(remainingLength downto 0); -- shak!
    message(511-remainingLength) <= '1'; -- shak!

    if tmp < 448 then
        k =: 448 - tmp - 1;
    else 
        tmp <= tmp - 448;
        k =: tmp + 511;
    end if;

    for i in 0 to (k-1) loop
        message(511-remainingLength-1-i) <= 0;
    end loop;

    binaryNum <= std_logic_vector(63 downto 0) (remainingLength);

    message(63 downto 0) <= binaryNum(63 downto 0);

    ans(blocknum-1) <= message;

    end process;    
end behavioral;