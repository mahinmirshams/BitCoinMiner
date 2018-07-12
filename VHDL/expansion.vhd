library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
PACKAGE MyType IS 
	type arr_stdVector is array(natural range<>) of std_logic_vector(31 downto 0);
	constant K : arr_stdVector := (
        x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5", x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174", x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da", x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967", x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85", x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070", 
        x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3", x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"be49a3f7", x"c67178f2"
    );
 END PACKAGE MyType; 

library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use work.MyType.all;
 use ieee.numeric_std.all;


--
entity expansion is 
   port(block512 : in  std_logic_vector(511 downto 0);
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

signal s0 , s1 : std_logic_vector(31 downto 0);


begin
  identifier : process( block512 )
  variable w : arr_stdVector(63 downto 0);
  variable t : integer:= 0;
  variable i : integer:= 0;

begin

        for i in 0 to 15 loop 
            w(i):= block512((511 - i*32) downto (511- i*32 - 31));
        end loop ;


for t in 16 to 63 loop 
    s1 <= sigma1(w(t - 1));
    s0 <= sigma0(w(t - 12));
       w(t) := std_logic_vector(unsigned(s1) + unsigned(w(t - 6)) + unsigned(s0) + unsigned(w(t- 15)));
end loop; 

        for i in 0 to 63 loop
            w(i) := permutation(w(i));
        end loop;

    ans <= w;
    end process;    
end behavioral;
