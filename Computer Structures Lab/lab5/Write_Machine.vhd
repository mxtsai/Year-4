----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:52:47 11/12/2018 
-- Design Name: 
-- Module Name:    Write_Machine_State - Behavioral 
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

entity Write_Machine_State is
    Port ( clk : in  STD_LOGIC := '0';
           step_en : in  STD_LOGIC := '0';
           ack_n : in  STD_LOGIC := '1';
           reset : in  STD_LOGIC := '0';
           in_init : out  STD_LOGIC := '1';
           as_n : out  STD_LOGIC := '1';
           wr_n : out  STD_LOGIC := '1';
           stop_n : out  STD_LOGIC := '1';
           counter_ce : out  STD_LOGIC := '0';
           state : out  STD_LOGIC_VECTOR (1 downto 0) := "00");
end Write_Machine_State;

architecture Behavioral of Write_Machine_State is
signal stateWM : std_logic_vector(1 downto 0) := "00";

constant wait_st : std_logic_vector (1 downto 0) := "00";
constant store_st : std_logic_vector (1 downto 0) := "01";
constant wait4ack_st : std_logic_vector (1 downto 0) := "10";
constant terminate_st : std_logic_vector (1 downto 0) := "11";

begin

	state<=stateWM;
		
		
	main: process(clk,ack_n)
	begin
		
		if (ack_n'event and ack_n='0') then
			stop_n <= '1';
		end if;
		
		
		if (clk'event and clk='1') then
		
		if reset = '1' then 
			in_init <= '1';
			as_n <= '1';
			wr_n <= '1';
			stop_n <= '1';
			stateWM <= wait_st;
		end if;
		
		
		
		
		
		case stateWM is 
		
			when wait_st => --in WAIT state
				if (step_en='1') then --get 'step_en' from RESA
						in_init <= '0'; --send 'in_init' = '0'
						as_n <= '0'; --send 'as_n' = '0'
						wr_n <= '0'; --for writing
						stop_n <= '1'; --just for safety
						stateWM<= store_st; --go to STORE state
				end if;
				
			when store_st => --in STORE state
				stateWM <= wait4ack_st;
				
			when wait4ack_st => --in WAIT4ACK state
				if (ack_n = '1') then
					stop_n <= '0';
				end if;
			
				if (ack_n = '0') then
						as_n <= '1'; --turn assertion back to '1'
						counter_ce <= '1'; --stop incrementing counter 
						wr_n <= '1';
						stateWM <= terminate_st; --go to LOADED state
				end if;
				
				
			when terminate_st => --in TERMINATE state
				in_init<='1';
				counter_ce<='0';
				stateWM <= wait_st;
				
				
			when others => null;
		end case;
		
		end if;
		
	end process;
	
	
end Behavioral;

