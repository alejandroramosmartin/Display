----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2020 16:33:53
-- Design Name: 
-- Module Name: Display - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display is
 Port ( 
    CLK100MHZ : in std_logic;
-- reset : in std_logic;
    CA  : out std_logic;
    CB  : out std_logic;
    CC  : out std_logic;
    CD  : out std_logic;
    CE  : out std_logic;
    CF  : out std_logic;
    CG  : out std_logic;
    AN  : out STD_LOGIC_VECTOR (7 downto 0);
    DP  : out std_logic
);
end Display;

architecture Behavioral of Display is
signal counter, next_counter : unsigned (1 downto 0) := "00";


signal toDisplay,centenas,decenas,unidades : unsigned (3 downto 0) := x"0";
signal aux_centenas,next_centenas,aux_decenas, next_decenas,aux_unidades : unsigned (9 downto 0) := (others => '0');
signal number, aux,next_aux : unsigned (9 downto 0) := "0010010110";
signal dec20,next_dec20,cent20,next_cent20 : unsigned (19 downto 0) := (others => '0');

signal display7 : STD_LOGIC_VECTOR (6 downto 0) := (others=>'0');
signal aux_AN, next_AN   : STD_LOGIC_VECTOR (7 downto 0) := (others=> '1');

signal clk10MHZ : STD_LOGIC;

component clk_wiz_0 
port(
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
 );
end component;

begin

CLK: clk_wiz_0 
port map(
    clk_out1 => clk10MHZ,
    clk_in1 => CLK100MHZ
 );

with toDisplay select display7 <=
	 --Descodificacion de numeros
"1001111"  when "0001", -- 1
"0010010"  when "0010", -- 2
"0000110"  when "0011", -- 3
"1001100"  when "0100", -- 4
"0100100"  when "0101", -- 5
"0100000"  when "0110", -- 6
"0001111"  when "0111", -- 7
"0000000"  when "1000", -- 8
"0001100"  when "1001", -- 9
"0000001"  when "0000", -- 0
"1111111" when others; 

process(clk10MHZ)
begin
    if(clk10MHZ'event and clk10MHZ='1') then
        counter <= next_counter;
        aux <= next_aux;
        aux_decenas <= next_decenas;
        aux_centenas <= next_centenas;
        cent20 <= next_cent20;
        dec20 <= next_dec20;
    end if;
end process;

process(aux,number, aux_centenas, aux_decenas, dec20,cent20)
begin
next_aux <= number;
next_centenas <= aux/100;
next_cent20 <= aux_centenas*100;
next_aux <= number - cent20(9 downto 0);
next_decenas <= aux/10;
next_dec20 <=  aux_decenas*10;
next_aux <= number - dec20(9 downto 0);
aux_unidades <= aux;

end process;

process(counter,centenas,decenas,unidades)
begin
    next_AN <= x"FF";
    toDisplay <= (others => '1');
    next_counter <= counter +1;

    if (counter = "01") then
        toDisplay <= centenas;
        next_AN <= x"FB";
    elsif (counter = "10") then
        toDisplay <= decenas;
        next_AN <= x"FD";
    elsif (counter = "11") then
        toDisplay<= unidades;
        next_AN <= x"FE";
    end if;
    
end process;

centenas <=aux_centenas(3 downto 0);
decenas  <=aux_decenas(3 downto 0);
unidades <=aux_unidades(3 downto 0);

CA <= display7(6);
CB <= display7(5);
CC <= display7(4);
CD <= display7(3);
CE <= display7(2);
CF <= display7(1); 
CG <= display7(0);
AN <= aux_AN; 
DP <= '1';

end Behavioral;
