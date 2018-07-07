library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


PACKAGE MyType IS 
    type array2d_64_32 is array (0 to 63) of unsigned(31 downto 0);
    type array2d_8_32 is array (0 to 7) of unsigned(31 downto 0);
 END PACKAGE MyType; 
 
library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use work.MyType.all;
 use ieee.numeric_std.all;

entity compression is
    Port ( W , K : in array2d_64_32;
           clk  , en , rst: in std_logic;
           Hi : in array2d_8_32;
           Hn :  out array2d_8_32);
end compression;

architecture RTL of compression is

signal A  : unsigned(31 downto 0) := x"6a09e667";
signal B  : unsigned(31 downto 0) := x"bb67ae85";
signal C  : unsigned(31 downto 0) := x"3c6ef372";
signal D  : unsigned(31 downto 0) := x"a54ff53a";
signal Ei : unsigned(31 downto 0) := x"510e527f";
signal F  : unsigned(31 downto 0) := x"9b05688c";
signal G  : unsigned(31 downto 0) := x"1f83d9ab";
signal H  : unsigned(31 downto 0) := x"5be0cd19";


function ch (x, y, z : unsigned(31 downto 0) ) return unsigned is
begin
    return (x and y) xor ((not y) and z) xor ((not x) and z);
end ch;

function maj (x, y, z : unsigned(31 downto 0) ) return unsigned is
begin
    return (x and y) xor (x and z) xor (y and z);
end maj;

function sigma0 (x : unsigned(31 downto 0) ) return unsigned is
begin
return unsigned((x ror 2) xor (x ror 13) xor (x ror 22) xor (x srl 7));
end sigma0;

function sigma1 (x : unsigned(31 downto 0) ) return unsigned is
begin
    return (x ror 6) xor (x ror 11) xor ( x ror 25);
end sigma1;

function sigma2 (x : unsigned(31 downto 0) ) return unsigned is
begin
    return (x ror 2) xor (x ror 3) xor (x ror 15) xor (x srl 5);
end sigma2;

signal temp1, temp2 : unsigned(31 downto 0);
begin

process(clk  )
begin 
    if (en = '1') then
    if(rst = '1')then
             A <= x"6a09e667";
             B  <= x"bb67ae85";
             C  <= x"3c6ef372";
             D  <= x"a54ff53a";
             Ei <= x"510e527f";
             F  <= x"9b05688c";
             G  <= x"1f83d9ab";
             H  <= x"5be0cd19";
    elsif (clk = '1') then
     for i in 0 to 63 loop
         temp2 <= H + sigma1(Ei) + ch(Ei, F, G) + K(i) + W(i);
         temp1 <= sigma0(A) + maj(A , B , C) + sigma2(C + D);
         H <= G;
         F <= Ei;
         D <= C;
         B <= A;
         G <= F;
         Ei <= D + temp1;
         C <= B;
         A <= temp1 + temp1 + temp1 - temp2;
     end loop;
     Hn(0) <= A  + Hi(0); 
     Hn(1) <= B + Hi(1);
     Hn(2) <= C  + Hi(2); 
     Hn(3) <= D + Hi(3); 
     Hn(4) <= Ei + Hi(4); 
     Hn(5) <= F + Hi(5);
     Hn(6) <= G  + Hi(6); 
     Hn(7) <= H + Hi(7); 
     
 end if;
 end if;
end process;

end RTL;
