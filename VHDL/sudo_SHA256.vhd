----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/06/2018 08:38:15 PM
-- Design Name: 
-- Module Name: sudo_SHA256 - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
PACKAGE MyType IS 
    type array2d_64_32 is array (63 downto 0) of std_logic_vector(31 downto 0);
    type array2d_8_32 is array (0 to 7) of std_logic_vector(31 downto 0);
 END PACKAGE MyType; 
 PACKAGE BUFFON IS type 
    input_arrray_t is array (63 downto 0) of std_logic_vector( 31 downto 0 );
 END PACKAGE BUFFON;  
 PACKAGE BUFFON2 IS type
     padded_arrray_t is array (63 downto 0) of std_logic_vector(511 downto 0) ;
 END PACKAGE BUFFON2; 

entity sudo_SHA256 is
    generic(N : integer);
    Port ( 
           clk    : in std_logic;
           reset  : in std_logic;
           enable : in std_logic;
           ready  : out std_logic; -- Ready to process the next block
           update : in  std_logic; -- Start processing the next block
           
           message : in std_logic_vector (N-1 downto 0);
           block_header : out  std_logic_vector (659 downto 0)
           
           );
end sudo_SHA256;

architecture Behavioral of sudo_SHA256 is
    -- padding
    component paddinng
    generic(
        input_var : INTEGER); --check
    port(msg : in std_logic_vector((input_var-1) downto 0);
        length : in std_logic;
        ans : out padded_arrray_t);
    end component;

    --expansion
    component expansion
    port(block512 : in std_logic_vector(511 downto 0);
        ans : out BUFFON);
    end component;

    --compression
    component compression
    Port ( W , K : in MyType;
           ready: in std_logic;
           Hn :  out std_logic_vector(255 downto 0));
    end component;


--other entities components

type state_type is (IDLE, BUSY_padding , BUSY_parsing , BUSY_expasion  , BUSY_compression, FINAL);
signal state : state_type;

signal W : array2d_64_32;
signal length : std_logic;
signal ans_padding : BUFFON2;

signal block512 : std_logic_vector(511 downto 0);
signal ans_expansion : BUFFON;

signal W , K : MyType;
signal ready: std_logic;
signal Hn :  std_logic_vector(255 downto 0);


signal current_w : std_logic_vector(31 downto 0);


-- Final hash values
signal Hi : array2d_8_32;
-- Intermediate hash values:
signal A, B, C, D, Ei, F, G, H : std_logic_vector(31 downto 0);


begin

    padding1: padding
    generic map (input_var  => 24)
    port map (msg => message, length => length, ans=>ans_padding);

    expansion1: expansion
    port map (block512 => block512, ans=>ans_expansion);

    compression1: compression
    port map (W => ans_expansion, K=>K, ready => ready , Hn => Hn); --check kon jahataro

ready <= '1' when state = IDLE else '0';

hasher: process(clk, reset, enable)
    variable i : integer := '0';
	begin
		if reset = '1' then
		-- set reset to other entites
			state <= IDLE;
		elsif rising_edge(clk) and enable = '1' then
			case state is
				when IDLE =>
					-- If new data is available, start hashing it:
					if update = '1' then
						A <= h0;
						B <= h1;
						C <= h2;
						D <= h3;
						Ei <= h4;
						F <= h5;
						G <= h6;
						H <= h7;
						state <= BUSY;
					end if;
				when BUSY =>
					-- Load a word of data and store it into the expanded message schedule:
					--W(index(current_iteration)) <= schedule(word_input, W, current_iteration);

					-- Run an interation of the compression function:
					--compress(a, b, c, d, e, f, g, h,
						--schedule(word_input, W, current_iteration),
						--constants(index(current_iteration)));

                    --
                    
                         for i in 0 to 63 loop
                            block512 <= ans_padding(i);
                        end loop ; 
                        
                                --k haro ezafe kon

                    




						state <= FINAL;
					
					
				when FINAL =>
					hi(0) <= std_logic_vector(unsigned(a) + unsigned(hi(0)));
					hi(1) <= std_logic_vector(unsigned(b) + unsigned(hi(1)));
					hi(2) <= std_logic_vector(unsigned(c) + unsigned(hi(2)));
					hi(3) <= std_logic_vector(unsigned(d) + unsigned(hi(3)));
					hi(4) <= std_logic_vector(unsigned(ei) + unsigned(hi(4)));
					hi(5) <= std_logic_vector(unsigned(f) + unsigned(hi(5)));
					hi(6) <= std_logic_vector(unsigned(g) + unsigned(hi(6)));
					hi(7) <= std_logic_vector(unsigned(h) + unsigned(hi(7)));
					state <= IDLE;
			end case;
		end if;
	end process hasher;

end Behavioral;
