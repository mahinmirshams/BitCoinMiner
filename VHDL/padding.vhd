 	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;


--
entity padding is
generic(
    input_var : integer :=32);
port(
    msg : in std_logic_vector(input_var-1 downto 0);
    res : out std_logic_vector((input_var+64+512)-((input_var+64)mod 512)-1 downto 0));
end padding;
--



architecture behavioral of padding is


begin
identifier : process(msg)
variable s2 : unsigned(5 downto 0):= "100000"; --100000
--variable s2 : unsigned(9 downto 0):= "1010100000";
begin
res(((input_var+64+512)-((input_var+64) mod 512))-1 downto ((input_var+64+512)-((input_var+64) mod 512))-input_var) <= msg;
res(((input_var+64+512)-((input_var+64) mod 512))-input_var-1 ) <= '1';
res(((input_var+64+512)-((input_var+64) mod 512))-input_var-2 downto 64) <= (others=>'0');
res(s2'high downto s2'low) <= std_logic_vector(s2);
res(64 downto (s2'high)+1 ) <= (others=>'0');



end process;
end behavioral;




