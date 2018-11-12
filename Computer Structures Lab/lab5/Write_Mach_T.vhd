-- Vhdl test bench created from schematic D:\Maxwell Documents\ACSL\HO5_Write\Write_Machine.sch - Mon Nov 12 21:06:43 2018
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
ENTITY Write_Machine_Write_Machine_sch_tb IS
END Write_Machine_Write_Machine_sch_tb;
ARCHITECTURE behavioral OF Write_Machine_Write_Machine_sch_tb IS 

   COMPONENT Write_Machine
   PORT( STATE	:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0); 
          STOP_N	:	OUT	STD_LOGIC; 
          WR_N	:	OUT	STD_LOGIC; 
          AS_N	:	OUT	STD_LOGIC; 
          IN_INIT	:	OUT	STD_LOGIC; 
          AO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          CLK	:	IN	STD_LOGIC; 
          STEP_EN	:	IN	STD_LOGIC; 
          ACK_N	:	IN	STD_LOGIC; 
          RESET	:	IN	STD_LOGIC; 
          DOUT	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0));
   END COMPONENT;

   SIGNAL STATE	:	STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
   SIGNAL STOP_N	:	STD_LOGIC := '1';
   SIGNAL WR_N	:	STD_LOGIC := '1';
   SIGNAL AS_N	:	STD_LOGIC := '1';
   SIGNAL IN_INIT	:	STD_LOGIC := '1';
   SIGNAL AO	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"00000000";
   SIGNAL CLK	:	STD_LOGIC;
   SIGNAL STEP_EN	:	STD_LOGIC := '0';
   SIGNAL ACK_N	:	STD_LOGIC := '1';
   SIGNAL RESET	:	STD_LOGIC := '0';
   SIGNAL DOUT	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"10101010";

BEGIN

   UUT: Write_Machine PORT MAP(
		STATE => STATE, 
		STOP_N => STOP_N, 
		WR_N => WR_N, 
		AS_N => AS_N, 
		IN_INIT => IN_INIT, 
		AO => AO, 
		CLK => CLK, 
		STEP_EN => STEP_EN, 
		ACK_N => ACK_N, 
		RESET => RESET, 
		DOUT => DOUT
   );
	
	
	
	CLK_process : process
		begin
			CLK <= '1';
			wait for 100 ns;
			CLK <= '0';
			wait for 100 ns;
		end process;


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
	
	wait for 200 ns; --wait 1 cc
		wait for 2 ns; --acual delay
		
		---------------------------------------------------------------------------
		--WRITE cycle 1 - begin
		STEP_EN <= '1';
		wait for 200 ns; 
		STEP_en <= '0';
		
		wait for 4*200 ns;
		ACK_N <= '0'; 
		wait for 200 ns;
		ACK_N <= '1';
		
		wait for 2*200 ns; --READ cycle 1 - completed
	
			----------------------------------------------------------------------------
		--READ cycle 2 - begin		
		STEP_EN <= '1';
		wait for 200 ns; 
		STEP_en <= '0';
		
		wait for 4*200 ns;
		ACK_N <= '0'; 
		wait for 200 ns;
		ACK_N <= '1';
		
		wait for 2*200 ns; --READ cycle 2 - completed
		
		----------------------------------------------------------------------------
		--READ cycle 3 - begin		
		STEP_EN <= '1';
		wait for 200 ns; 
		STEP_en <= '0';
		
		wait for 200 ns;
		
		RESET <='1';
		wait for 200 ns;
		RESET <= '0';
	
	
	
	
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
