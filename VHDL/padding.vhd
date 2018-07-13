 	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;


--
entity padding is
generic(
    input_var : integer:= 24);
port(
    msg : in std_logic_vector(input_var-1 downto 0);
    res : out std_logic_vector(511 downto 0));
end padding;
--

architecture behavioral of padding is

begin
identifier : process(msg)

variable k : integer := 0;
variable tmp : integer := 0;
-- variable blocknum : integer := 0 ;

variable binaryNum: unsigned(63 downto 0):= (others => '0');
-- variable remainingLength :integer := input_var;


begin
-- blocknum := length1/ 512 + 1;
-- blocknum := blocknum +1 ;
-- tmp := length1 mod 512;

-- blocknum := blocknum-2;

-- for j in 0 to blocknum loop
-- ans(j) <= msg(remainingLength downto remainingLength -512);
-- remainingLength := remainingLength - 512;
-- end loop;
-- blocknum := blocknum+1;
-- message(511 downto 512 - remainingLength) <= msg(remainingLength downto 0); -- shak!
-- message(511-remainingLength) <= '1'; -- shak!

-- if tmp < 448 then
-- k := 448 - tmp - 1;
-- else
-- tmp := tmp - 448;
-- k := tmp + 511;
-- end if;

-- for i in 0 to (k-1) loop
-- message(511 - remainingLength-1-i) <= '0';
-- end loop;

-- binaryNum := remainingLength;

-- message(63 downto 0) <= std_logic_vector(to_unsigned(binaryNum, 64));

-- ans(blocknum-1) <= message;
    tmp := input_var-1 mod 512;
    if(tmp<448) then
    k := 448 - tmp -1;
    else
    tmp := tmp - 448;
    k := tmp + 511;
    end if;

for J in 0 to input_var-1 loop
    res(J) <= msg(J);
end loop;

res(input_var) <= '1';

for I in 0 to k-1 loop
res(input_var-1+I+2) <= '0';
end loop;

binaryNum := to_unsigned(input_var-1, 64);

for I in 0 to 63 loop
res(k+input_var-1+I+1) <= binaryNum(63 - I);
end loop;

end process;
end behavioral;