-- Vhdl test bench created from schematic D:\Maxwell Documents\ACSL\HO4\Monitoring_Slave.sch - Tue Nov 06 10:06:46 2018
--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the 
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;
ENTITY Monitoring_Slave_Monitoring_Slave_sch_tb IS
END Monitoring_Slave_Monitoring_Slave_sch_tb;
ARCHITECTURE behavioral OF Monitoring_Slave_Monitoring_Slave_sch_tb IS 

   COMPONENT Monitoring_Slave
   PORT( Monit_Data	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          CLK	:	IN	STD_LOGIC; 
          STEP_ENAB	:	IN	STD_LOGIC; 
          STOPN	:	IN	STD_LOGIC; 
          IN_INITIAL	:	IN	STD_LOGIC; 
          Input1	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          Input2	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          S_DOUT	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          S_ACK_OUT	:	OUT	STD_LOGIC; 
          CARD_SELECT	:	IN	STD_LOGIC; 
          WRIT_IN	:	IN	STD_LOGIC; 
          AI	:	IN	STD_LOGIC_VECTOR (9 DOWNTO 0));
   END COMPONENT;

   SIGNAL Monit_Data	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"00000000";
   SIGNAL CLK	:	STD_LOGIC;
   SIGNAL STEP_ENAB	:	STD_LOGIC;
   SIGNAL STOPN	:	STD_LOGIC;
   SIGNAL IN_INITIAL	:	STD_LOGIC;
   SIGNAL Input1	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL Input2	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL S_DOUT	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL S_ACK_OUT	:	STD_LOGIC;
   SIGNAL CARD_SELECT	:	STD_LOGIC;
   SIGNAL WRIT_IN	:	STD_LOGIC;
   SIGNAL AI	:	STD_LOGIC_VECTOR (9 DOWNTO 0);

BEGIN

   UUT: Monitoring_Slave PORT MAP(
		Monit_Data => Monit_Data, 
		CLK => CLK, 
		STEP_ENAB => STEP_ENAB, 
		STOPN => STOPN, 
		IN_INITIAL => IN_INITIAL, 
		Input1 => Input1, 
		Input2 => Input2, 
		S_DOUT => S_DOUT, 
		S_ACK_OUT => S_ACK_OUT, 
		CARD_SELECT => CARD_SELECT, 
		WRIT_IN => WRIT_IN, 
		AI => AI
   );

-- *** Test Bench - User Defined Section ***

	CLK_PROCESS :process
		begin
			CLK <= '0';
			wait for 100ns;
			CLK <= '1';
			wait for 100ns;
		end process;
		
	data :process
		begin
			wait until rising_edge(CLK);
			Monit_Data <= std_logic_vector(unsigned(Monit_Data)+1);
		end process;

   tb : PROCESS
   BEGIN
		
		--start with some initial values
		STEP_ENAB <= '0'; 
		IN_INITIAL <= '1'; 
		STOPN <= '1'; --is '1' when idle
		
		Input1 <= X"00000000"; --some dummy value
		Input2 <= X"00000001"; --some dummy value
		
		
		AI<="0000000000"; -- select the first input to HO3 slave 
		--Note: AI[9:0] doesn't affect the process of writing Monit_Data into RAM[counter]
		--therefore, CardSel = '0' all this time
		
		CARD_SELECT <= '0'; -- no address on BUS
		WRIT_IN <= '1'; --not writing, all this time is '1'
		
		--monitor_data is '0'
		
		wait for 2 ns; --real-life delay
		wait for 100 ns; --to let step_en come up on rising edge of clock
		
		wait for 200 ns; -- one CC
		--monitor_data is '1'
		STEP_ENAB <= '1'; --one pulse of starting step, and LA_WE is '1'
		
		wait for 200 ns;
		--monitor data is '2'
		--counter is at address '0' 
		
		STEP_ENAB <= '0'; --set to LOW after 1 CC
		IN_INITIAL <= '0'; -- in_init also goes low with falling edge of step_en
		
		--RAM[ 0 ] = 2
		
		wait for 2*200 ns; --one CC
		--RAM[ 1 ] = 3
		
		--one CC
		--RAM[ 2 ] = 4
		--counter incremented ('2' -> '3')
		
		--right after the rising edge of CLK now
		STOPN<='0'; --stop writing to ram
		wait for 2*200 ns; --wait for two CC
		
		-- Monit_Data = 6
		STOPN<='1'; --now keep writing
		--RAM[3] = 7
		
		wait for 200 ns;
		--RAM[4] = 8
		
		IN_INITIAL <= '1'; 
		--RAM[5] = 9 <--This one is actually garbage
		
		wait for 3*200 ns; --wait for out output to settle down
		
		--Now, status will give us an output of '05'
		
		--------------     Ready to test SDO and SACKN       --------------------------
		
		--Test RAM ADDRESS : 00000 : expect decimal 2
		AI <= "0000000000";
		CARD_SELECT <='1';
		wait until S_ACK_OUT = '0';
		wait for 200 ns;
		CARD_SELECT <='0';
		wait for 200 ns;
		
		--Test RAM ADDRESS : 00100 : expect decimal 8
		AI <= "0000000100";
		CARD_SELECT <='1';
		wait until S_ACK_OUT = '0';
		wait for 200 ns;
		CARD_SELECT <='0';
		wait for 200 ns;
		
		--Test ID + STATUS : 
		AI <= "0000100000";
		CARD_SELECT <='1';
		wait until S_ACK_OUT = '0';
		wait for 200 ns;
		CARD_SELECT <='0';
		wait for 200 ns;
		
		--Test IN2 : 
		AI <= "0001100000";
		CARD_SELECT <='1';
		wait until S_ACK_OUT = '0';
		wait for 200 ns;
		CARD_SELECT <='0';
		wait for 200 ns;
		
		--Test this special signal : 
		AI <= "0001100001"; --increment by one
		CARD_SELECT <='1';
		wait until S_ACK_OUT = '0';
		wait for 200 ns;
		CARD_SELECT <='0';
		wait for 200 ns;
		
		--we expect to get the same signal out since only PA[1:0] matters to the MUX
		wait;
		
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
