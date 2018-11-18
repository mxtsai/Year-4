--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:51:59 11/18/2018
-- Design Name:   
-- Module Name:   D:/Maxwell Documents/ACSL/HO6/MAC_Test.vhd
-- Project Name:  HO6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory_Access_Machine
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MAC_Test IS
END MAC_Test;
 
ARCHITECTURE behavior OF MAC_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_Access_Machine
    PORT(
         clk : IN  std_logic;
         mr : IN  std_logic;
         mw : IN  std_logic;
         ackn : IN  std_logic;
			reset : IN std_logic;
         busy : OUT  std_logic;
         asn : OUT  std_logic;
         wrn : OUT  std_logic;
         mac_state : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal mr : std_logic := '0';
   signal mw : std_logic := '0';
   signal ackn : std_logic := '0';
	signal reset : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal asn : std_logic;
   signal wrn : std_logic;
   signal mac_state : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 200 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_Access_Machine PORT MAP (
          clk => clk,
          mr => mr,
          mw => mw,
          ackn => ackn,
			 reset => reset,
          busy => busy,
          asn => asn,
          wrn => wrn,
          mac_state => mac_state
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
		
		wait for 300ns;
		wait for 2ns; --actual delay
		
		--Testing Read------------------------------------------
		mr<='1'; --send read signal
		wait for 3*200ns;
		
		ackn<='1'; --return ack signal for 1 cc
		wait for 200ns;
		ackn<='0';
		
		mr<='0';
		
		wait for 2*200ns;
		
		--Testing Write-----------------------------------------
		mw<='1'; --send write signal
		wait for 3*200ns;
		
		ackn<='1'; --return ack signal for 1 cc
		wait for 200ns;
		ackn<='0';
		
		mw<='0';
		
		wait for 2*200ns;
		
		--Testing Reset-----------------------------------------
		mw<='1'; --send write signal again
		wait for 2*200ns;
		
		reset<='1'; --reset suddenly placed in
		wait for 200ns;
		reset<='0';
		
		mw<='0';

      wait;
   end process;

END;
