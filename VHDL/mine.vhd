library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.BUFFON.all;

entity mine is generic(input_var : integer := 32);
    Port (
        clk : in std_logic;
        rst : in std_logic;
        inp : in std_logic_vector(input_var-1 downto 0);
        outp : out std_logic_vector(255 downto 0)
     );
end entity;

architecture Behavioral of mine is
     
component sha256 is generic(input_var : integer := 32 );
Port (
      input_sha : in std_logic_vector(input_var-1 downto 0);
      output_sha : out std_logic_vector(255 downto 0)
 );

end component;

type state is (init,run,i,final);
signal current_state : state := init;
   
signal targ : std_logic_vector(255 downto 0):=x"1010101010101010101010101010101010101010101010101010101010101010";
signal vrsion : std_logic_vector(31 downto 0):= x"02000000";
signal hashprev : std_logic_vector(255 downto 0):= x"17975b97c18ed1f7e255adf297599b55330edab87803c8170100000000000000";
signal hashmerkel : std_logic_vector(255 downto 0) ;
signal timee : std_logic_vector(31 downto 0):= x"358b0553";
signal difficulty : std_logic_vector(31 downto 0):= x"5350f119";
signal nonce : std_logic_vector(31 downto 0):= x"00000000";
signal hash : std_logic_vector(255 downto 0):= x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
signal blockh : std_logic_vector(639 downto 0);
signal hashmid : std_logic_vector(255 downto 0);


begin


sudo : sha256 generic map (input_var => 32) port map (inp , hashmerkel);
sudo1 : sha256 generic map (input_var => 672) port map (nonce & blockh , hashmid);
sudo2 : sha256 generic map (input_var => 256) port map (hashmid , hash);


process(clk,rst) 
begin
    if rising_edge(clk) then
         if rst = '1' then
            current_state <= init;
         else
            case current_state is
                  when init =>
                  blockh <= vrsion & hashprev & hashmerkel & timee & difficulty & nonce;
                  current_state <= run;
                     
                  when run =>
                          
                      if (unsigned(hash) > unsigned(targ)) then
          
                         current_state <= i;
                      else
                         current_state <= final;
                      end if;
                  when i =>
                     if (unsigned(hash) > unsigned(targ)) then
                        nonce <= std_logic_vector(unsigned(nonce) + "0001");
                        current_state <=i;
                     else 
                        current_state <=final;
                     end if;
                     
                  when final =>
                        outp <= hash;
                        current_state <=final;
                  when others =>
                        current_state <=init;
               end case;

         end if;
      end if;

end process;






end architecture;