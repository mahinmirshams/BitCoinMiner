library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg.all;
use ieee.numeric_std.all;


PACKAGE MyType IS type array2d_64_32 is array (63 downto 0) of unsigned(31 downto 0);
 END PACKAGE MyType; 


entity compression is
    Port ( W , K : in MyType;
           ready: in std_logic;
           Hn :  out unsigned(255 downto 0));
end compression;

architecture RTL of compression is

signal H0_A  : unsigned(31 downto 0) := x"6a09e667";
signal H1_B  : unsigned(31 downto 0) := x"bb67ae85";
signal H2_C  : unsigned(31 downto 0) := x"3c6ef372";
signal H3_D  : unsigned(31 downto 0) := x"a54ff53a";
signal H4_E : unsigned(31 downto 0) := x"510e527f";
signal H5_F  : unsigned(31 downto 0) := x"9b05688c";
signal H6_G  : unsigned(31 downto 0) := x"1f83d9ab";
signal H7_H  : unsigned(31 downto 0) := x"5be0cd19";


function ch (x, y, z : unsigned(31 downto 0) ) return unsigned is
	variable temp1: unsigned(31 downto 0);
	variable temp2: unsigned(31 downto 0);
	variable temp3: unsigned(31 downto 0);
begin
    temp1 := x and y;
    temp2 := not(y) and z;
    temp3 := not(x) and z;
	return temp1 xor temp2 xor temp3;
end ch;

function maj (x, y, z : unsigned(31 downto 0) ) return unsigned is
	variable temp1: unsigned(31 downto 0);
	variable temp2: unsigned(31 downto 0);
	variable temp3: unsigned(31 downto 0);
begin
    temp1 := x and z;
    temp2 := x and y;
    temp3 := y and z;
	return temp1 xor temp2 xor temp3;
end maj;

function sigma0 (x : unsigned(31 downto 0) ) return unsigned is
	variable temp1: unsigned(31 downto 0);
	variable temp2: unsigned(31 downto 0);
	variable temp3: unsigned(31 downto 0);
	variable temp4: unsigned(31 downto 0);
begin
    temp1 := x ror 2;
    temp2 := x ror 13;
    temp3 := x ror 22;
    temp4 := x srl 7;
	return temp1 xor temp2 xor temp3 xor temp4;
end sigma0;

function sigma1 (x : unsigned(31 downto 0) ) return unsigned is
	variable temp1: unsigned(31 downto 0);
	variable temp2: unsigned(31 downto 0);
	variable temp3: unsigned(31 downto 0);
begin
    temp1 := x ror 6;
    temp2 := x ror 11;
    temp3 := x ror 25;
	return temp1 xor temp2 xor temp3;
end sigma1;

function sigma2 (x : unsigned(31 downto 0) ) return unsigned is
	variable temp1: unsigned(31 downto 0);
	variable temp2: unsigned(31 downto 0);
	variable temp3: unsigned(31 downto 0);
	Variable temp4: unsigned(31 downto 0);
begin
    temp1 := x ror 2;
    temp2 := x ror 3;
    temp3 := x ror 15;
    emp4 := x srl 5;
	return temp1 xor temp2 xor temp3 xor temp4;
end sigma2;

signal temp1, temp2 : unsigned(31 downto 0);
begin

process( ready)
begin 
    if (ready = '1') then
     for i in 0 to 63 loop
         temp2 <= H7_H + sigma1(H4_E) + ch(H4_E, f, g) + K(i) + W(i);
         temp1 <= sigma0(H0_A) + maj(H0_A , H1_B , H2_C) + sigma2(H2_C + H3_D);
         H7_H <= H6_G;
         H5_F <= H4_E;
         H3_D <= H2_C;
         H1_B <= H0_A;
         H6_G <= H5_F;
         H4_E <= H3_D + temp1;
         H2_C <= H1_B;
         H0_A <= temp1 + temp1 + temp1 - temp2;
     end loop;
 end if;
end process;

end RTL;
