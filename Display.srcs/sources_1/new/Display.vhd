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
    reset : in std_logic;
    number : in unsigned (9 downto 0); --numero de segundos que quedan de grabación
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
signal counter, next_counter : unsigned (0 downto 0) := "0";

signal toDisplay, decenas, unidades : unsigned (3 downto 0) := (others => '0');
signal aux_decenas, next_decenas, aux_unidades, next_unidades : unsigned (9 downto 0) := (others => '0');

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
        aux_decenas <= next_decenas;
        aux_unidades <= next_unidades;
    end if;
end process;

-- Divide en decenas y unidades el valor de number
process(number, aux_decenas)
begin

next_decenas <= number/10;
next_unidades <= number - aux_decenas*10;

end process;

-- Activa en cada flanco de reloj el display con la cifra correspondiente a las decenas o unidades
process(counter,decenas,unidades)
begin
    next_AN <= x"FF";
    toDisplay <= (others => '1');
    next_counter <= counter + 1;
    
    if (counter = "0") then
        toDisplay <= decenas;
        next_AN <= x"FD";
    elsif (counter = "1") then
        toDisplay<= unidades;
        next_AN <= x"FE";
    end if;
    
end process;

-- Asignación de las señales de control del display
decenas <= aux_decenas(3 downto 0);
unidades <= aux_unidades(3 downto 0);

-- Asignación de las salidas
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
