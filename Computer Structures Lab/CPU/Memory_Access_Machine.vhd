----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:14:55 11/18/2018 
-- Design Name: 
-- Module Name:    Memory_Access_Machine - Behavioral 
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

entity Memory_Access_Machine is
    Port ( clk : in  STD_LOGIC;
           mr : in  STD_LOGIC := '0';
           mw : in  STD_LOGIC := '0';
           ack : in  STD_LOGIC := '0';
			  reset : in STD_LOGIC := '0';
           busy : out  STD_LOGIC := '0';
           asn : out  STD_LOGIC := '1';
           wrn : out  STD_LOGIC := '1';
			  stopn : out STD_LOGIC := '1';
           mac_state : out  STD_LOGIC_VECTOR (1 downto 0) := "00");
end Memory_Access_Machine;

architecture Behavioral of Memory_Access_Machine is

signal stateMAC : std_logic_vector(1 downto 0) := "00";
signal req : std_logic := '0';
signal stopn_out : std_logic := '1';

constant wait4req : std_logic_vector (1 downto 0) := "00";
constant wait4ack : std_logic_vector (1 downto 0) := "01";
constant nextState : std_logic_vector (1 downto 0) := "10";

begin
	
	--non clock synced signals
	req <= mr or mw; --internal request signal
	busy <= req and not(ack); --define busy output signal
	mac_state <= stateMAC; --output current state
	
	stopn <= '1' when ack = '1' else
			stopn_out;

	
	main : process(clk)
	begin
		
		if (clk'event and clk='1') then
		
			if reset = '1' then
				asn <= '1';
				wrn <= '1';
				stateMAC <= wait4req;
				stopn_out <= '1';
			end if;
		
			case stateMAC is
				when wait4req => -----------------------------------------------IDLE STATE
					if req='1' then --has request
						stateMAC<= wait4ack; --updates state
						asn <= '0'; --set assertion low (active)
						wrn <= not(mw); --if writing, set low, else high
						stopn_out <= '1';
					end if;
				
				when wait4ack => -----------------------------------------------WAIT4ACK STATE
					if stopn_out = '1' and ack='0' then --only for the first cc after enter wait4ack state
						stopn_out <= '0';
					end if;
					
					if ack = '1' then 
						stateMAC <= nextState;
						asn <= '1'; --reset the values
						wrn <= '1'; 
						stopn_out <= '1';
					end if;
				
				when nextState=> -----------------------------------------------FINISHING STATE
					
					stateMAC <= wait4req;
					
				when others => null;
			
			
			end case;
		
		end if;
		
	end process;

end Behavioral;

