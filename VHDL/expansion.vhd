 	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;



--
entity expansion is
port(block512 : in std_logic_vector(511 downto 0);
ans : out arr_stdVector(0 to 63)
);
end expansion;
--



architecture behavioral of expansion is

function sigma0 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
variable rot17,rot14,shf12,output :std_logic_vector(31 downto 0);
begin
rot17(31 downto 15) := x(16 downto 0);
rot17(14 downto 0) := x(31 downto 17);
rot14(31 downto 18) := x(13 downto 0);
rot14(17 downto 0) := x(31 downto 14);
shf12 := "000000000000" & x(31 downto 12);
output := rot17 xor rot14 xor shf12;

return output;

end sigma0;

function sigma1 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
variable rot9,rot19,shf9,output :std_logic_vector(31 downto 0);
begin
rot9(31 downto 23) := x(8 downto 0);
rot9(22 downto 0) := x(31 downto 9);
rot19(31 downto 13) := x(18 downto 0);
rot19(12 downto 0) := x(31 downto 19);
shf9:="000000000" & x(31 downto 9);
output := rot9 xor rot19 xor shf9;

return output;
end function;

function permutation (input : std_logic_vector(31 downto 0)) return std_logic_vector is
variable outp : std_logic_vector(31 downto 0);
begin
for i in 0 to 7 loop
outp(31 - i) := input(i);
end loop;
outp(23 downto 16) := input(15 downto 8);
for i in 0 to 15 loop
outp(i) := input(31 - i);
end loop;
return outp;
end function;

--signal s0 , s1 : std_logic_vector(31 downto 0);


begin
identifier : process( block512 )
variable w : arr_stdVector(0 to 63);


begin

for i in 0 to 15 loop
w(i):= block512((511 - i*32) downto (511- i*32 - 31));
end loop ;


for t in 16 to 63 loop
-- s1 <= sigma1(w(t - 1));
-- s0 <= sigma0(w(t - 12));
--w(t) := std_logic_vector(unsigned(s1) + unsigned(w(t - 6)) + unsigned(s0) + unsigned(w(t- 15)));
w(t) := std_logic_vector(unsigned(sigma1(w(t-1))) + unsigned(w(t-6)) + unsigned(sigma0(w(t-12))) + unsigned(w(t-15)));
end loop;

for i in 0 to 63 loop
w(i) := permutation(w(i));
end loop;

ans <= w;
end process;
end behavioral;