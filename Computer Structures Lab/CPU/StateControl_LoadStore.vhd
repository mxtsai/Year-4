----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:10:50 11/22/2018 
-- Design Name: 
-- Module Name:    State_Control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity State_Control is
    Port ( clk : in  STD_LOGIC;
           stepen : in  STD_LOGIC := '0';
           reset : in  STD_LOGIC := '0';
           busy : in  STD_LOGIC := '0';
           opcode : in  STD_LOGIC_VECTOR (5 downto 0) := "UUUUUU";
           mr : out  STD_LOGIC := '0';
           mw : out  STD_LOGIC := '0';
			  stateCTL : out STD_LOGIC_VECTOR (2 downto 0) := "000";
           ir_ce : out  STD_LOGIC := '0';
           ao_sel : out  STD_LOGIC := '0';
           reg_c_ce : out  STD_LOGIC :='0';
           reg_b_ce : out  STD_LOGIC :='0';
           gpr_we : out  STD_LOGIC := '0';
           pc_ce : out  STD_LOGIC := '0';  
			  in_init : out STD_LOGIC := '1');
			  
end State_Control;

architecture Behavioral of State_Control is

signal curState : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal curStateEqFetch : STD_LOGIC := '0';
signal curStateEqLoad : STD_LOGIC := '0';

constant initSt : STD_LOGIC_VECTOR (2 downto 0) := "000";
constant fetchSt : STD_LOGIC_VECTOR (2 downto 0) := "001";
constant decodeSt : STD_LOGIC_VECTOR (2 downto 0) := "010";
constant storeSt : STD_LOGIC_VECTOR (2 downto 0) := "011";
constant loadSt : STD_LOGIC_VECTOR (2 downto 0) := "100";
constant wbiSt : STD_LOGIC_VECTOR (2 downto 0) := "101";
constant haltSt : STD_LOGIC_VECTOR (2 downto 0) := "111";

constant loadOp : STD_LOGIC_VECTOR (5 downto 0) := "100011";
constant storeOp : STD_LOGIC_VECTOR (5 downto 0) := "101011";


begin

	stateCTL <= curState;
	
	
	curStateEqFetch <= '1' when curState=fetchSt else
							 '0';
							 
	curStateEqLoad <= '1' when curState=loadSt else
							 '0';
							 
	ir_ce <= (curStateEqFetch xor busy) and curStateEqFetch;
	
	reg_c_ce <= curStateEqLoad xor busy;
	
	main: process(clk)
	begin
	
	
	
	if (clk'event and clk = '1') then
	
		if reset='1' then
			curState <= initSt;
			
		end if;
	
		case curState is
			when initSt =>
				if stepen = '1' then
					mr <= '1'; --start read transaction with MAC for next instruction
					mw <= '0'; --only read, not writing
					curState <= fetchSt;
					in_init <= '0';
				end if;
				
			when fetchSt =>
				if busy = '0' then
					mr <= '0'; --got the instruction
					reg_b_ce <= '1'; --get read to accept value at register[Badr]
					pc_ce <= '1'; --updates PC in next cc (in decode state)
					curState <= decodeSt;
				end if;
				
			when decodeSt=>
				ao_sel <= '1'; --select the address out as the immediate
				reg_b_ce <= '0'; --stop reading value into register B
				pc_ce <= '0'; --stop incrementing PC counter
				
				if opcode = loadOp then
				
					mr<='1'; --send read request to MAC
					mw<='0'; 
					curState <= loadSt; --enter load state
				elsif opcode = storeOp then
					curState <= storeSt;
					mr<='0';
					mw<='1'; --send write request to MAC
				else
					curState <= haltSt;
				end if;
				
			when storeSt=>
				if busy='0' then
					ao_sel <='0';
					mw<='0';
					mr<='0';
					in_init <='1';
					curState <= initSt;
				end if;
				
			when haltSt=>
				--curState<=haltSt;
			
			
			when loadSt=>
				
				if busy='0' then --enter next state when busy low of 1cc
					curState <= wbiSt;
					mr<='0';
					mw<='0';
					gpr_we <= '1';
				end if;
							
			when wbiSt=>
				gpr_we <= '0';
				ao_sel<='0';
				in_init <= '1';
				curState <= initSt;
				
				
			when others => NULL;
	
		end case;
		
	end if;
	
	end process;

end Behavioral;

