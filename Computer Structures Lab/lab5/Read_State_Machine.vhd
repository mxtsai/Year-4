----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:35 11/11/2018 
-- Design Name: 
-- Module Name:    Read_State_Machine - Behavioral 
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

entity Read_State_Machine is
    Port ( clk : in  STD_LOGIC;
           step_en : in  STD_LOGIC := '0';
           ack_n : in  STD_LOGIC := '1';
           reset : in  STD_LOGIC := '0';
           counter_ce : out  STD_LOGIC := '0';
           counter_rst : out  STD_LOGIC := '0';
           reg_ce : out  STD_LOGIC := '0';
           state : out  STD_LOGIC_VECTOR (1 downto 0) := "00";
           in_init : out  STD_LOGIC := '1';
           as_n : out  STD_LOGIC := '1';
           wr_n : out  STD_LOGIC := '1';
           stop_n : out  STD_LOGIC := '1');
end Read_State_Machine;

architecture Behavioral of Read_State_Machine is

signal stateRM : std_logic_vector(1 downto 0) := "00";

constant wait_st : std_logic_vector (1 downto 0) := "00";
constant fetch_st : std_logic_vector (1 downto 0) := "01";
constant wait4ack_st : std_logic_vector (1 downto 0) := "10";
constant loaded_st : std_logic_vector (1 downto 0) := "11";

begin

	state <= stateRM;  --update the output 'state' to internal signal
	
	reg_ce <= not(ack_n); --so that reg_ce can switch immediately
	
	counter_rst <= reset; --real time update reset
	
	main: process(CLK)
	begin
		
		if (clk'event and clk='1') then --only rising edge of clock
		
		
		if reset = '1' then 
			in_init <= '1';
			as_n <= '1';
			wr_n <= '1';
			stop_n <= '1';
			stateRM <= wait_st;
			
		--else 
			--stateRM <= stateRM;
		end if;
			
			case stateRM is
				when wait_st =>  --in WAIT state
					if (step_en='1') then --get 'step_en' from RESA
						in_init <= '0'; --send 'in_init' = '0'
						as_n <= '0'; --send 'as_n' = '0'
						wr_n <= '1'; --just for safety
						stop_n <= '1'; --just for safety
						stateRM<= fetch_st; --go to FETCH state
					--else
					--	in_init <= '1';
					--	as_n <= '1';
					--	wr_n <= '1';
					--	stop_n <= '1';
					--	stateRM<= wait_st;
					end if;
					
				when fetch_st => --in FETCH state
					
					stateRM <= wait4ack_st; --go to WAIT4ACK state
					
				when wait4ack_st => --in WAIT4ACK state
					
					if (ack_n = '0') then
						as_n <= '1'; --turn assertion back to '1'
						counter_ce <= '1'; --stop incrementing counter 
						stateRM <= loaded_st; --go to LOADED state
					--else
					--	stateRM <= stateRM;
					end if;
					
				when loaded_st => --in LOADED state
					counter_ce <= '0'; --stop incrementing counter 
					in_init <= '1'; -- reset 'in_init'
					stateRM <= wait_st; --back to WAIT state
					
				when others => null;
					
			end case; 
	
		
		end if;
	end process;


end Behavioral;

