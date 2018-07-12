
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/05/2018 12:56:40 PM
-- Design Name: 
-- Module Name: expansion - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pkg.all;
--use work.pack.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity expansion_perm is
  generic (length : integer := 31);
  Port (msg: in unsigned(length downto 0);
        clk: in std_logic;
        w1: out arr2d := (others => (others => '0'));
        w2: out arr2d := (others => (others => '0'));
        two_block: out std_logic := '0'
         );
end expansion_perm;

architecture Behavioral of expansion_perm is

shared variable binaryNum: unsigned(63 downto 0):= (others => '0');
shared variable p: integer;

--impure function decToBinary(n: integer) return unsigned(63 downto 0) is
--    variable i: integer := 0;
--    variable nVar: integer := n;
--    variable x: integer;
--begin
--    while (nVar > 0) loop
----        x := (nVar/2)*2;
----        y := nVar - x ;
--        x := nVar mod 2;
--        binaryNum(i) := to_unsigned(std_logic(x));
--        nVar := nVar / 2;
--        i := i+1;
--    end loop;
--    return binaryNum;
--end decToBinary;

--impure function string_to_binary (msg: string; length: integer) return unsigned(1023 downto 0) is
--    variable res: unsigned(1023 downto 0);
--begin
--    for I in 0 to length loop
----        binaryNum := decToBinary(character'pos(msg(I)));
--        binaryNum := to_unsigned(character'pos(msg(I)),8);
--        for J in 0 to 7 loop
--            res(I*8+J) := binaryNum(7-J);
--        end loop;
--    end loop;
--    return res;
--end string_to_binary;

impure function padding( msg: unsigned(length downto 0)) return unsigned is

    variable res: unsigned(1023 downto 0);
    variable tmp, k: integer;
    --variable length: integer := 31;
    
begin

    p := length/512; --if p = 1 : 2 block
    
    tmp := length mod 512;
    if(tmp<448) then
        k := 448 - tmp -1;
    else
        tmp := tmp - 448;
        k := tmp + 511;
    end if;
    
    for J in 0 to length loop
       res(J) := msg(J);
    end loop;

    res(length+1) := '1';

    for I in 0 to k-1 loop
        res(length+I+2) := '0';
    end loop;
    
    binaryNum := to_unsigned(length, 64);
    
    for I in 0 to 63 loop
        res(k+length+I+1) := binaryNum(63 - I);
    end loop;
    
    return res;
end;

function sig0 (w: unsigned(31 downto 0)) return unsigned is

    variable r1,r2,s0: unsigned(31 downto 0);
    
begin
     r1 := w ror 17;
     r2 := w ror 14;
     s0 := w srl 12;
     return  r1 xor r2 xor s0;
end sig0;

function sig1 (w: unsigned(31 downto 0)) return unsigned is

    variable r1,r2,s0: unsigned(31 downto 0);
    
begin
     r1 := w ror 9;
     r2 := w ror 19;
     s0 := w srl 9;
     return  r1 xor r2 xor s0;
end sig1;

function perm (inp: unsigned(31 downto 0)) return unsigned is

    variable res: unsigned(31 downto 0);
    
begin
    for I in 0 to 15 loop
        res(31-I) := inp(I);
    end loop;
    for I in 0 to 23 loop
        res(I) := inp(I);
    end loop;
    for I in 0 to 31 loop
        res(31-I) := inp(I);
    end loop;
    return res;
end perm;

function expansion (blck: unsigned(511 downto 0)) return arr2d is

    variable s0,s1: unsigned(31 downto 0);
    variable w: arr2d;

begin

for I in 0 to 15 loop
        for J in 0 to 31 loop
            w(I)(J) := blck(I*32+J);
        end loop;
    end loop;
    for I in 16 to 63 loop
        s1 := sig1(w(I-1));
        s0 := sig0(w(I-12));
        w(I) :=s1+ w(I-6)+ s0+ w(I-15);
    end loop;
    return w;
end expansion;



signal padding_msg: unsigned(1023 downto 0);
signal res1,res2: arr2d;

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(length > 448)then
            two_block<='1';
        end if;
        padding_msg <= padding(msg);

            res1 <= expansion(padding_msg(511 downto 0));
            for I in 0 to 63 loop
                w1(I) <= perm(res1(I));
                w2(I) <= (others => '0');
            end loop;
        if (p = 1) then
            two_block <= '1';
            res2 <= expansion(padding_msg(1023 downto 512));
                    for I in 0 to 63 loop
                        w2(I) <= perm(res2(I));
                    end loop;
        end if;
    end if;
end process;
end Behavioral;