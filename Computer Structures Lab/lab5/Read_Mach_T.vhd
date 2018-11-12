-- Vhdl test bench created from schematic D:\Maxwell Documents\ACSL\HO5_Read\Read_Machine.sch - Sun Nov 11 22:11:17 2018
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
ENTITY Read_Machine_Read_Machine_sch_tb IS
END Read_Machine_Read_Machine_sch_tb;
ARCHITECTURE behavioral OF Read_Machine_Read_Machine_sch_tb IS 

   COMPONENT Read_Machine
   PORT( CLK	:	IN	STD_LOGIC; 
          STEP_EN	:	IN	STD_LOGIC; 
          ACK_N	:	IN	STD_LOGIC; 
          RESET	:	IN	STD_LOGIC; 
          DIN	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          AS_N	:	OUT	STD_LOGIC; 
          WR_N	:	OUT	STD_LOGIC; 
          STOP_N	:	OUT	STD_LOGIC; 
          STATE	:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0); 
          DO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          AO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          IN_INIT	:	OUT	STD_LOGIC);
   END COMPONENT;

   SIGNAL CLK	:	STD_LOGIC;
   SIGNAL STEP_EN	:	STD_LOGIC := '0';
   SIGNAL ACK_N	:	STD_LOGIC := '1';
   SIGNAL RESET	:	STD_LOGIC := '0';
   SIGNAL DIN	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"11111111";
   SIGNAL AS_N	:	STD_LOGIC := '1';
   SIGNAL WR_N	:	STD_LOGIC := '1';
   SIGNAL STOP_N	:	STD_LOGIC := '1';
   SIGNAL STATE	:	STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
   SIGNAL DO	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"00000000";
   SIGNAL AO	:	STD_LOGIC_VECTOR (31 DOWNTO 0) := X"00000000";
   SIGNAL IN_INIT	:	STD_LOGIC;

BEGIN

   UUT: Read_Machine PORT MAP(
		CLK => CLK, 
		STEP_EN => STEP_EN, 
		ACK_N => ACK_N, 
		RESET => RESET, 
		DIN => DIN, 
		AS_N => AS_N, 
		WR_N => WR_N, 
		STOP_N => STOP_N, 
		STATE => STATE, 
		DO => DO, 
		AO => AO, 
		IN_INIT => IN_INIT
   );

-- *** Test Bench - User Defined Section ***

	CLK_process : process
		begin
			CLK <= '1';
			wait for 100 ns;
			CLK <= '0';
			wait for 100 ns;
		end process;

   tb : PROCESS
   BEGIN
		wait for 200 ns; --wait 1 cc
		wait for 2 ns; --acual delay
		
		---------------------------------------------------------------------------
		--READ cycle 1 - begin
		STEP_EN <= '1';
		wait for 200 ns; 
		STEP_en <= '0';
		
		wait for 3*200 ns;
		ACK_N <= '0'; 
		wait for 200 ns;
		ACK_N <= '1';
		
		wait for 2*200 ns; --READ cycle 1 - completed
		----------------------------------------------------------------------------
		--READ cycle 2 - begin
		DIN <= X"10101010";
		
		STEP_EN <= '1';
		wait for 200 ns; 
		STEP_en <= '0';
		
		wait for 3*200 ns;
		ACK_N <= '0'; 
		wait for 200 ns;
		ACK_N <= '1';
		
		wait for 2*200 ns; --READ cycle 2 - completed
		
		----------------------------------------------------------------------------
		--READ cycle 3 - begin
		DIN <= X"01010101";
		
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
