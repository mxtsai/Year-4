-- Vhdl test bench created from schematic D:\Maxwell Documents\ACSL\HO4\Logic_Anal.sch - Wed Oct 31 23:20:35 2018
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
ENTITY Logic_Anal_Logic_Anal_sch_tb IS
END Logic_Anal_Logic_Anal_sch_tb;
ARCHITECTURE behavioral OF Logic_Anal_Logic_Anal_sch_tb IS 

   COMPONENT Logic_Anal
   PORT( M_DATA	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          CLKK	:	IN	STD_LOGIC; 
          A_IN	:	IN	STD_LOGIC_VECTOR (4 DOWNTO 0); 
          STEP_ENN	:	IN	STD_LOGIC; 
          STOP_NN	:	IN	STD_LOGIC; 
          IN_INITT	:	IN	STD_LOGIC; 
          D_OUTT	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          STATUSS	:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0));
   END COMPONENT;

   SIGNAL M_DATA	:	STD_LOGIC_VECTOR (31 DOWNTO 0) :=  X"00000000";
   SIGNAL CLKK	:	STD_LOGIC;
   SIGNAL A_IN	:	STD_LOGIC_VECTOR (4 DOWNTO 0) := "00000";
   SIGNAL STEP_ENN	:	STD_LOGIC;
   SIGNAL STOP_NN	:	STD_LOGIC;
   SIGNAL IN_INITT	:	STD_LOGIC;
   SIGNAL D_OUTT	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL STATUSS	:	STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN

   UUT: Logic_Anal PORT MAP(
		M_DATA => M_DATA, 
		CLKK => CLKK, 
		A_IN => A_IN, 
		STEP_ENN => STEP_ENN, 
		STOP_NN => STOP_NN, 
		IN_INITT => IN_INITT, 
		D_OUTT => D_OUTT, 
		STATUSS => STATUSS
   );

-- *** Test Bench - User Defined Section ***
   CLK_PROCESS :process
		begin
			
			CLKK <= '1';
			wait for 100ns;
			CLKK <= '0';
			wait for 100ns;
			
		end process;
	
	data: process
		begin
			wait until rising_edge(CLKK);
			M_DATA <= std_logic_vector(unsigned(M_DATA)+1);
			A_IN <= std_logic_vector(unsigned(A_IN)+1);
		end process;
	
	tb : PROCESS
   BEGIN
      
		IN_INITT <= '1';
		STOP_NN <= '1';
		
		wait for 200ns;
		wait for 2ns;
		
		STEP_ENN <= '1';
	
		wait for 200ns;
		
		STEP_ENN <= '0';
		IN_INITT <= '0';
		
		
		
		wait for 5*200ns;
		
		STOP_NN <= '0';
		
		wait for 3*200ns;
		
		STOP_nn <= '1';
		
		wait for 5*200ns;
		
		
		IN_INITT <= '1';
		
		
		WAIT; -- will wait forever
		
   END PROCESS;
-- *** End Test Bench - User Defined Section ***
END;
