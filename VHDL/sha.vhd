library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;

entity sha256 is generic(input_var : integer :=96 );
  Port (
        input_sha : in std_logic_vector(input_var-1 downto 0);
        output_sha : out std_logic_vector(255 downto 0)
   );
end sha256;

architecture Behavioral of sha256 is

    component padding is 
    generic(
            input_var : integer :=96 );
       port(
            msg : in std_logic_vector(input_var-1 downto 0);
            res : out std_logic_vector((input_var+64+512)-((input_var+64)mod 512)-1 downto 0));
    end component;

    component expansion is 
    port(block512 : in  std_logic_vector(511 downto 0);
         ans : out arr_stdVector(0 to 63)
         );
      end component;

    component compression is
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
    end component;

    signal padded : std_logic_vector((input_var+64+512)-((input_var+64)mod 512)-1 downto 0);
    signal block512 : std_logic_vector(511 downto 0);
    signal W1: arr_stdVector(0 to 63);
    signal W2: arr_stdVector(0 to 63);

    signal in_H0 : arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H1: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H2: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H3: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H4: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H5: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H6: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal in_H7: arr_stdVector(0 to (((input_var+64+512)-((input_var+64)mod 512))/512)-1);
    signal given_H0 : std_logic_vector(31 downto 0) :=(x"6a09e667");
    signal given_H1 : std_logic_vector(31 downto 0) :=(x"bb67ae85");
    signal given_H2 : std_logic_vector(31 downto 0) :=(x"3c6ef372");
    signal given_H3 : std_logic_vector(31 downto 0) :=(x"a54ff53a");
    signal given_H4 : std_logic_vector(31 downto 0) :=(x"510e527f");
    signal given_H5 : std_logic_vector(31 downto 0) :=(x"9b05688c");
    signal given_H6 : std_logic_vector(31 downto 0) :=(x"1f83d9ab");
    signal given_H7 : std_logic_vector(31 downto 0) :=(x"5be0cd19");
    
    signal hout : arr_stdVector(0 to 7);

begin


mypad: padding generic map(input_var) port map (input_sha , padded);

myfor: for i in (((input_var+64+512)-((input_var+64)mod 512))/512)-1 downto 0 generate
  
    
    myfirstif : if i = (((input_var+64+512)-((input_var+64)mod 512))/512)-1 generate
    
    myexpan: expansion port map (padded(i*512 +511 downto i*512) , W1);
        comp : compression port map(W1,given_H0,given_H1,given_H2,given_H3,given_H4,given_H5,given_H6,given_H7,in_H0(i),in_H1(i),in_H2(i),in_H3(i),in_H4(i),in_H5(i),in_H6(i),in_H7(i));

    end generate;
    mysecondif : if i /= (((input_var+64+512)-((input_var+64)mod 512))/512)-1 generate
    
    myexpan: expansion port map (padded(i*512 +511 downto i*512) , W2);

    comp : compression port map(W2,in_H0(i+1),in_H1(i+1),in_H2(i+1),in_H3(i+1),in_H4(i+1),in_H5(i+1),in_H6(i+1),in_H7(i+1),in_H0(i),in_H1(i),in_H2(i),in_H3(i),in_H4(i),in_H5(i),in_H6(i),in_H7(i));
  
    end generate; 

end generate;

--end generate;

output_sha <= in_H0(0) & in_H1(0) & in_H2(0) & in_H3(0) & in_H4(0) & in_H5(0) & in_H6(0) & in_H7(0);


end Behavioral;
