library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;


entity expandcomp is
generic(
    input_var : integer:= 24);
  Port (
   -- inp : in std_logic_vector(511 downto 0);
    msg : in std_logic_vector(input_var-1 downto 0);
    initial_H0 : in std_logic_vector(31 downto 0);
    initial_H1 : in std_logic_vector(31 downto 0);
    initial_H2 : in std_logic_vector(31 downto 0);
    initial_H3 : in std_logic_vector(31 downto 0);
    initial_H4 : in std_logic_vector(31 downto 0);
    initial_H5 : in std_logic_vector(31 downto 0);
    initial_H6 : in std_logic_vector(31 downto 0);
    initial_H7 : in std_logic_vector(31 downto 0);
    Houtp0 : out std_logic_vector(31 downto 0);
    Houtp1 : out std_logic_vector(31 downto 0);
    Houtp2 : out std_logic_vector(31 downto 0);
    Houtp3 : out std_logic_vector(31 downto 0);
    Houtp4 : out std_logic_vector(31 downto 0);
    Houtp5 : out std_logic_vector(31 downto 0);
    Houtp6 : out std_logic_vector(31 downto 0);
    Houtp7 : out std_logic_vector(31 downto 0)
   );
end expandcomp;

architecture Behavioral of expandcomp is

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


component padding is
generic(
    input_var : integer:= 24);
port(
    msg : in std_logic_vector(input_var-1 downto 0);
    res : out std_logic_vector(511 downto 0));
end component;

signal W : arr_stdVector(0 to 63);
signal result : std_logic_vector(511 downto 0); 

begin

pad : padding port map (msg , result);
exp : expansion  port map(result ,w);
comp : compression port map(w,initial_H0,initial_H1,initial_H2,initial_H3,initial_H4,initial_H5,initial_H6,initial_H7,Houtp0,Houtp1,Houtp2,Houtp3,Houtp4,Houtp5,Houtp6,Houtp7);


end Behavioral;
