library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;



entity compression is
    Port ( W  : in arr_stdVector(0 to 63);
           in_H0 : in std_logic_vector(31 downto 0);
		   in_H1 : in std_logic_vector(31 downto 0);
		   in_H2 : in std_logic_vector(31 downto 0);
		   in_H3 : in std_logic_vector(31 downto 0);
		   in_H4 : in std_logic_vector(31 downto 0);
		   in_H5 : in std_logic_vector(31 downto 0);
		   in_H6 : in std_logic_vector(31 downto 0);
		   in_H7 : in std_logic_vector(31 downto 0);		
           out_H0 :  out std_logic_vector(31 downto 0);
		   out_H1 :  out std_logic_vector(31 downto 0);
		   out_H2 :  out std_logic_vector(31 downto 0);
		   out_H3 :  out std_logic_vector(31 downto 0);
		   out_H4 :  out std_logic_vector(31 downto 0);
		   out_H5 :  out std_logic_vector(31 downto 0);
		   out_H6 :  out std_logic_vector(31 downto 0);
		   out_H7 :  out std_logic_vector(31 downto 0)
		   );
end compression;

architecture RTL of compression is

    function ch(x , y , z : std_logic_vector(31 downto 0)) return std_logic_vector is
        variable t1,t2,t3,output:std_logic_vector(31 downto 0);
        begin

            t1 := x and y;
            t2 := not(y) and z;
            t3 := not(x) and z;
            output := t1 xor t2 xor t3;
            return output;
	end ch;
	

    function maj(x , y , z : std_logic_vector(31 downto 0)) return std_logic_vector is
        variable t1,t2,t3,output:std_logic_vector(31 downto 0);
        begin
            t1 := x and z;
            t2 := x and y;
            t3 := y and z;
            output := t1 xor t2 xor t3;
            return output;
    end maj;
	
    function sigma0(x : std_logic_vector(31 downto 0)) return std_logic_vector is
        variable rot2, rot13, rot22, shf7, output: std_logic_vector(31 downto 0);
        begin
            rot2 := x(1 downto 0) & x(31 downto 2);
            rot13 := x(12 downto 0) & x(31 downto 13);
            rot22 := x(21 downto 0) & x(31 downto 22);
            shf7 :="0000000" & x(31 downto 7);
            output := rot2 xor rot13 xor rot22 xor shf7;
            return output;
    end sigma0; 
	
    function sigma1(x : std_logic_vector(31 downto 0)) return std_logic_vector is
        variable rot6,rot11,rot25,output : std_logic_vector(31 downto 0);
        begin
            rot6 := x(5 downto 0) & x(31 downto 6);
            rot11 := x(10 downto 0) & x(31 downto 11);
            rot25 := x(24 downto 0) & x(31 downto 25);

            output := rot6 xor rot11 xor rot25;
            return output;

    end sigma1;

    function sigma2(x: std_logic_vector(31 downto 0)) return std_logic_vector is
        variable rot2,rot3,rot15,shf5,outp : std_logic_vector(31 downto 0);
        begin
            rot2 := x(1 downto 0) & x(31 downto 2);
            rot3 := x(2 downto 0) & x(31 downto 3);
            rot15:= x(14 downto 0) & x(31 downto 15);
            shf5 := "00000" & x(31 downto 5); 

            outp := rot2 xor rot3 xor rot15 xor shf5;
            return outp;

    end sigma2;

begin
process( W, in_H0,in_H1,in_H2,in_H3,in_H4,in_H5,in_H6,in_H7 )
variable hout : arr_stdVector(0 to 7);
variable A, B, C, D, Ei, F, G, H, temp1, temp2 : std_logic_vector(31 downto 0);
begin 
		hout(0) := in_H0;
		hout(1) := in_H1;
		hout(2) := in_H2;
		hout(3) := in_H3;
		hout(4) := in_H4;
		hout(5) := in_H5;
		hout(6) := in_H6;
		hout(7) := in_H7;
		
		A := hout(0);
		B := hout(1);
		C := hout(2);
		D := hout(3);
		Ei := hout(4);
		F := hout(5);
		G := hout(6);
		H := hout(7);		
	
     for i in 0 to 63 loop
         temp2 := std_logic_vector(unsigned(H) + unsigned(sigma1(Ei)) + unsigned(ch(Ei, F, G)) + unsigned(K(i)) + unsigned(W(i)));
         temp1 := std_logic_vector(unsigned(sigma0(A)) + unsigned(maj(A , B , C)) + unsigned(sigma2(std_logic_vector(unsigned(C) + unsigned(D)))));
         H := G;
         F := Ei;
         D := C;
         B := A;
         G := F;
         Ei := std_logic_vector(unsigned(D) + unsigned(temp1));
         C := B;
         A := std_logic_vector(unsigned(temp1)+unsigned(temp1)+unsigned(temp1)-unsigned(temp2));
     end loop;
	 
		hout(0) := std_logic_vector(unsigned(A)+ unsigned(hout(0)));
		hout(1) := std_logic_vector(unsigned(B)+ unsigned(hout(1)));
		hout(2) := std_logic_vector(unsigned(C)+ unsigned(hout(2)));
		hout(3) := std_logic_vector(unsigned(D)+ unsigned(hout(3)));
		hout(4) := std_logic_vector(unsigned(Ei)+ unsigned(hout(4)));
		hout(5) := std_logic_vector(unsigned(F)+ unsigned(hout(5)));
		hout(6) := std_logic_vector(unsigned(G)+ unsigned(hout(6)));
		hout(7) := std_logic_vector(unsigned(H)+ unsigned(hout(7)));
		
		out_H0 <= hout(0);
		out_H1 <= hout(1);
		out_H2 <= hout(2);
		out_H3 <= hout(3);
		out_H4 <= hout(4);
		out_H5 <= hout(5);
		out_H6 <= hout(6);
		out_H7 <= hout(7);
     
end process;

end RTL;
