----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2020 20:21:29
-- Design Name: 
-- Module Name: TB_Display - Behavioral
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

entity TB_Display is
--  Port ( );
end TB_Display;

architecture Behavioral of TB_Display is
component Display is
 Port ( 
    CLK100MHZ : in std_logic;
    reset : in std_logic;
    number : in unsigned (9 downto 0);
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
end component;

signal    CLK100MHZ :  std_logic;
signal    reset :  std_logic := '0';
signal    number :  unsigned (9 downto 0) := "0010010110";
signal    CA  :  std_logic;
signal    CB  :  std_logic;
signal    CC  :  std_logic;
signal    CD  :  std_logic;
signal    CE  :  std_logic;
signal    CF  :  std_logic;
signal    CG  :  std_logic;
signal    AN  :  STD_LOGIC_VECTOR (7 downto 0);
signal    DP  :  std_logic;

constant clk_period : time := 10ns;
begin
DISPLAY_1: Display 
 Port Map( 
    CLK100MHZ => CLK100MHZ,
    reset => reset,
    number => number,
    CB  =>CB,
    CC  =>CC,
    CD  =>CD,
    CE  =>CE,
    CF  =>CF,
    CG  =>CG,
    AN  =>AN,
    DP  =>DP
);

clk_process :process 
begin
CLK100MHZ <= '0';
wait for clk_period/2;
CLK100MHZ <= '1';
wait for clk_period/2;
end process;

end Behavioral;
