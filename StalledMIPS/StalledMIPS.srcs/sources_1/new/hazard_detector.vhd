----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 03:25:05 PM
-- Design Name: 
-- Module Name: hazard_detector - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_detector is
    Port ( IF_ID_opcode : in STD_LOGIC;
           IF_ID_rs : in STD_LOGIC;
           IF_ID_rt : in STD_LOGIC;
           ID_EX_RegWrite : in STD_LOGIC;
           ID_EX_RegDst : in STD_LOGIC;
           EX_MEM_RegWrite : in STD_LOGIC;
           EX_MEM_RegDst : in STD_LOGIC;
           hazard_detected : out STD_LOGIC);
end hazard_detector;

architecture Behavioral of hazard_detector is

begin

hazard_detected <= IF_ID_opcode != "111" && ID_EX_RegWrite = '1' && ID_EX_RegDst = IF_ID_rs;

end Behavioral;
