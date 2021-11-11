----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 11:11:39 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity IFC is
    Port ( clk : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstrAddress: out STD_LOGIC_VECTOR (15 downto 0));
end IFC;

architecture Behavioral of IFC is

-- for the Instruction memory (ROM)
-- functionality; adds up the numbers from 1 to M[0] - 1 and stores the result in M[1] and RF[4]
type rom_type is array(0 to 255) of std_logic_vector(15 downto 0); --todo
signal rom_data: rom_type := (
-- VERSION with hazards (*s mark RAW hazards)
--    "0010000100000001", --0: $2 <= $0 + 1                   | 0x2101 
--    "0100000010000000", --1: $1 <= M[$0 + 0]                | 0x4080 
--    "0000000000110000", --2: $3 <= $0 + $0                  | 0x0030
--    "1000100010000011", --3: beq if $2 == $1 jump forward 3 | 0x8883 * (first time: RF[1], next times RF[2])
--    "0000110100110000", --4: $3 <= $3 + $2                  | 0x0D30 * (first time only, for RF[3])
--    "0010100100000001", --5: $2 <= $2 + 1                   | 0x2901
--    "1110000000000011", --6: jump 3                         | 0xE003
--    "0110000110000001", --7: m[$0 + 1] <= $3                | 0x6181 *
--    "0100001000000001", --8: $4 <= m[$0 + 1] --> for check  | 0x4201 
--    "0001000001000001", --9: $4 <= $4 - $0 --> for check    | 0x1041 *
--    "0000000000000000", --10: NOP                           | 0x0000
--    others => x"0000"

-- HAZARDLESS VERSION
    "0010000100000001", --0: $2 <= $0 + 1                   | 0x2101
    "0100000010000000", --1: $1 <= M[$0 + 0]                | 0x4080
    "0000000000110000", --2: $3 <= $0 + $0                  | 0x0030
    "0000000000000000", --3: NOP                            | 0x0000
    "1000100010000111", --4: beq if $2 == $1 jump forward 7 | 0x8887
    "0000000000000000", --5: NOP                            | 0x0000 
    "0000000000000000", --6: NOP                            | 0x0000 
    "0000000000000000", --7: NOP                            | 0x0000 
    "0000110100110000", --8: $3 <= $3 + $2                  | 0x0D30
    "0010100100000001", --9: $2 <= $2 + 1                   | 0x2901
    "1110000000000100", --10: jump 4                        | 0xE004
    "0000000000000000", --11: NOP                           | 0x0000
    "0110000110000001", --12: m[$0 + 1] <= $3               | 0x6181
    "0100001000000001", --13: $4 <= m[$0 + 1] --> for check | 0x4201
    "0000000000000000", --14: NOP                           | 0x0000
    "0000000000000000", --15: NOP                           | 0x0000 
    "0001000001000001", --16: sub $4 <= $4 - $0 --> for check |0x1041
    "0000000000000000", --17: NOP                           | 0x0000
    others => x"0000"
);

signal Instr_with_branch_addr, Instr_with_jump_addr, inner_NextInstrAddress: std_logic_vector(15 downto 0);
signal Instr_address: std_logic_vector(15 downto 0) := x"0000";

begin

Instr <= rom_data(conv_integer(Instr_address(7 downto 0))); --todo

PC: process(clk) 
begin
    if clk'event and clk = '1' then
        Instr_address <= Instr_with_jump_addr;
    end if;
end process;

PC_ADDER: process(Instr_address) 
begin
    inner_NextInstrAddress <= Instr_address + 1;
end process;

BRANCH_MUX: process(PCSrc, BranchAddress, inner_NextInstrAddress) 
begin
    if PCSrc = '1' then
        Instr_with_branch_addr <= BranchAddress;
    else
        Instr_with_branch_addr <= inner_NextInstrAddress;
    end if;
end process;

JUMP_MUX: process(Jump, JumpAddress, Instr_with_branch_addr) 
begin
    if Jump = '1' then
        Instr_with_jump_addr <= JumpAddress;
    else
        Instr_with_jump_addr <= Instr_with_branch_addr;
    end if;
end process;

NextInstrAddress <= inner_NextInstrAddress;

end Behavioral;
