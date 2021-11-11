----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 06:26:39 PM
-- Design Name: 
-- Module Name: NOP_detector - Behavioral
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

-- Detects instructions which have no effect
entity NOP_detector is
    Port ( OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           imm: in STD_LOGIC_VECTOR(15 downto 0);
           NOP_detected : out STD_LOGIC);
end NOP_detector;

architecture Behavioral of NOP_detector is

begin
    NOP_detected <= '1' when (OpCode = "000" and RegDst = "000") or -- R type instruction with destination = RF[0] (writing to RF[0] has no effect)
                             ((OpCode = "100" or OpCode = "101" or OpCode = "110") and imm = x"0000") or -- Branch instruction with imm = 0
                             ((Opcode = "001" or OpCode = "010") and RegDst = "000") -- ADDI or LW instruction with destination = RF[0] (writing to RF[0] has no effect)
                        else '0';

end Behavioral;
