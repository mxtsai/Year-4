----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:10 10/16/2018 
-- Design Name: 
-- Module Name:    resa_bus - Behavioral 
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

entity resa_bus is
    Port ( A : out  STD_LOGIC_VECTOR (31 downto 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
				--address from resa-bus to SLV 
           D : inout  STD_LOGIC_VECTOR (31 downto 0); --data to&from resa-bus to SLV
           rd_req : in  STD_LOGIC; -- from CPU to resa-bus
           wr_req : in  STD_LOGIC; --from CPU to resa-bus
           busy : in  STD_LOGIC; --from CPU to resa-bus : instruction begin
           done : out  STD_LOGIC := '0'; --resa-bus to CPU
			  CLK : in STD_LOGIC; 
			  AO : in STD_LOGIC_VECTOR (31 downto 0); --address from CPU to resa-bus
			  DO : in STD_LOGIC_VECTOR (31 downto 0); --data from CPU to resa-bus
			  DI : out STD_LOGIC_VECTOR (31 downto 0) := X"00000000"; 
			  --data to resa-bus to CPU
			  as_n: out STD_LOGIC :='1'; --inform slave transaction begin
			  wr_n : out STD_LOGIC :='1'; --inform slave of write request
			  ack_n : in STD_LOGIC :='1'; --SLV to resa-bus : transaction complete
			  in_init: out STD_LOGIC := '1' --resa-bus to SLV : instruction begin
			  );
end resa_bus;

architecture Behavioral of resa_bus is
	signal R_AD:STD_LOGIC_VECTOR (31 downto 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
	--register to hold address
	signal R_DO:STD_LOGIC_VECTOR (31 downto 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
	--register to hold data from CPU to slave
	signal R_DI:STD_LOGIC_VECTOR (31 downto 0) := X"00000000"; 
	--register to hold data from slave to CPU
	signal CE0:STD_LOGIC :='0' ; --CE for R_DI
	signal CE1:STD_LOGIC :='0' ; --CE for R_DO
	signal CE2:STD_LOGIC :='0' ; --CE for R_AD
	signal DE2:STD_LOGIC :='0'; --gate for address
	signal DE1:STD_LOGIC :='0'; --gate for dataIO gate, default is readIO
	
	signal INIT:STD_LOGIC := '1'; --keeps track of instruction 
	signal TRANS:STD_LOGIC := '1'; --keeps track of transaction
	signal WRIT_N:STD_LOGIC := '1'; --replica of wr_n
	signal DO_SMTH:STD_LOGIC := '0'; --do something (wr_req or rd_req)
	
begin

----------------------------------- All Time Runners ----------------------------------------------------
in_init<='0' when busy = '1' else '1';
INIT<='0' when busy = '1' else '1'; --write op

DI<=R_DI; --connect register R_DI to CPU's data_in

DO_SMTH<='1' when (wr_req or rd_req) = '1' else '0'; --a trigger for doing something request

--Loading address before tansaction begin
CE2<='1' when DO_SMTH='1' else '0'; --clock enable for address register

--Loading data before transaction begin
CE1<='1' when DO_SMTH='1' and wr_req = '1' else '0'; 
	--when write request is HIGH, clock enabled for R_DO register

--Routing the dataIO path
	--WRITING 
	CE1<='1' when wr_req = '1' else '0'; --sets CE1 for the R_DO for the data to write 
	DE1<='1' when WRIT_N = '0' else '0'; --when wr_n is set to WRITE, then DE1 outputs stored value

--For Reading
	CE0<='1' when WRIT_N = '1' and ack_n = '0' else '0'; --Immediately read data from SLV to R_DI register

--Send 'Done' when ack_n is recieved
	done<='1' when ack_n = '0' else '0'; --follows exactly as the negation of ack_n


----------------------------------- Trigger for Registers----------------------------------------------------


A<=R_AD when DE2='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
D<=R_DO when DE1='1' else (others=>'Z');


R_AD_trigger : process(clk,CE2)
	begin
		if clk'event and clk='1' then
			if CE2='1' then R_AD<=AO; else R_AD<=R_AD; end if;
			--if CE2 is HIGH, store AO value into register, otherwise, store prev value
		end if;
	end process;

dataIO_trigger : process(clk,CE1,CE0) 
	begin
		if clk'event and clk='1' then
			if CE1='1' then R_DO<=DO; else R_DO<=R_DO; end if; --for write oper.
			if CE0='1' then R_DI<=D; else R_DI<=R_DI; end if; --for read oper.
		end if;
	end process;

------------------------------------------------------------------------------------------
assertion : process(clk) --handles when the CPU sends intruction to resa-bus
	begin
	
	if clk'event and clk='1' then
		if INIT='0' then
			if DO_SMTH='1' then --haven't entered transaction yet
				wr_n<=not(wr_req); --set write request (output use)
				WRIT_N <=not(wr_req); --for internal use (replica of above) 
				DE2<='1'; --enable address register to start outputting address
				as_n<='0'; --send assertion signal
				TRANS<='0'; --entered transaction
			
			elsif ack_n='0' then
				DE2<='0'; --reset the address output to SLV
				
				wr_n<='1'; --reset the WR port
				WRIT_N<='1';
				
				as_n <='1'; --resets the AS port
				TRANS<='1';
				
			end if;
		end if;
	end if;
	
	end process;

------------------------------------------------------------------------------------------
end Behavioral;

