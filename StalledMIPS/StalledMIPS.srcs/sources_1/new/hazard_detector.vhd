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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_detector is
    Port ( IF_ID_OpCode : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rs : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rt : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_imm: in STD_LOGIC_VECTOR(15 downto 0);
           ID_EX_RegWrite : in STD_LOGIC;
           ID_EX_RegDst : in STD_LOGIC_VECTOR(2 downto 0);
           EX_MEM_RegWrite : in STD_LOGIC;
           EX_MEM_RegDst : in STD_LOGIC_VECTOR(2 downto 0);
           hazard_detected : out STD_LOGIC);
end hazard_detector;

architecture Behavioral of hazard_detector is

component NOP_detector is
    Port ( OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           imm: in STD_LOGIC_VECTOR(15 downto 0);
           NOP_detected : out STD_LOGIC);
end component;

signal IF_ID_is_NOP: STD_LOGIC;

begin

NOP_detector_comp: NOP_detector port map (
        OpCode => IF_ID_OpCode,
        RegDst => IF_ID_RegDst,
        imm => IF_ID_imm,
        NOP_detected => IF_ID_is_NOP
    );

hazard_detected <= '1' when IF_ID_is_NOP = '0' and
                            ((IF_ID_OpCode /= "111" and ID_EX_RegWrite = '1' and ID_EX_RegDst = IF_ID_rs and IF_ID_rs /= "000") or
                             (IF_ID_OpCode /= "111" and EX_MEM_RegWrite = '1' and EX_MEM_RegDst = IF_ID_rs and IF_ID_rs /= "000") or
                             ((IF_ID_OpCode = "000" or (IF_ID_OpCode >= "011" and IF_ID_opcode <= "110")) and ID_EX_RegWrite = '1' and ID_EX_RegDst = IF_ID_rt and IF_ID_rt /= "000") or
                             ((IF_ID_OpCode = "000" or (IF_ID_OpCode >= "011" and IF_ID_opcode <= "110")) and EX_MEM_RegWrite = '1' and EX_MEM_RegDst = IF_ID_rt and IF_ID_rt /= "000"))
                       else '0';

end Behavioral;
