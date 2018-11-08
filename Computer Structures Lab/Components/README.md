# Description of Components 

## Master Signals

`Step_En` : will be '1' for one CC when master is about to begin a (set of) instruction \ else '0'  
`In_Init` : will be '0' on the falling edge of `Step_En` \ will be '1' one CC after `ACK` signal is sent back from slave \ is '1' when idle  
  
### Design of Trivial Master (Handout 3)
`cnt[31:0]` : whenever `Step_En` is '1' for one CC, counter inside `broja` will count for a certain amount of cycles. Its outputs a 32 bit string of counts (eg, `0x00000000`,`0x01010101`,`0x02020202`,`0x03030303`) and internally within Trivial Master, this 32 bit string is also known as `wide[31:0]`.  

`reg_adr[4:0]` : only for READ  >> `state(3)=1` & `WE=0` for Master's RAM >> `reg_out[31:0]=RAM[reg_adr]`    
  
 
`reg_out[31:0]` : the value stored in the Master's 32x32bit RAM given address `ADD[4:0]` from `mux5bit`  
`step_num[4:0]` : value output by the `step_counter` within the Master  
`state[3:0]` : the state of the Master   
`reg_write[4:0]` : the address in the Master's RAM that will be written to in the next CC  

**Notice**
 * When `Broja` writes to Master's RAM, `wide[31:0]` is being written to RAM's `D[31:0]` as data and `wide[4:0]` is written to `ADD[4:0]` as address. This means that the 32bit value of any of the 32 "slots" in the RAM holds information on both the value and the address at the time it was written to.     

## SDRAM Partitioning
`AI[9:0]` is divided into : `BA[2:0]|PA[1:0]|WA[4:0]`  
Our SDRAM has 2^10 = 1024 addresses of 32 bit length each.  

We partition the 1024 addresses into 2^3=8 **blocks** (aka. slave ID) ==> each **block** has 1024/8 = 128 addresses to choose from.  
We split the 128 addresses into 2^2 = 4 **pages** (aka. categories) ==> each **page** has 128/4 = 32 addresses.   
To access the 32 **word** (aka. addresses), we need to use `WA[4:0]` to access each individual address of 32-bit length.

  * For the monitor-slave in HO3, we decided to use BA="000" as the ID of the slave.  
  Therefore, we set the following addresses for the corresponding input to the monitor slave  
  
  | Monitor Slave Input | Address (Binary) | Address (Hex) | Name (for RESA) |
  |---|---|---|---|
  |       in1           | 0000000000 (= 0 dec) |  0x000  |   ramvalue      |
  |       in2           | 0000100000 (=32) |  0x020  |   stepnum       |
  |       in3           | 0001000000 (=64) |  0x040  |   idstate       |
  |       in4           | 0001100000 (=96) |  0x060  |   regwrite      |


## Slave Control
This Slave Control interface is standard for all slaves connected to the BUS.
All slaves share the same `WR_IN_N` and `CARD_SEL` signals, and that's why `BA[2:0]` is needed to differentiate between a master talking to a specific slave.

  Inputs: `BA[2:0]`,`CARD_SEL`,`WR_IN_N`  
  Outputs: `SACK_N`
  
  
  `WR_IN_N` : when master wants to write => '0' / else (including read) => '1'  
              (for master talking to slave monitor, it is always '1' since masters (RESA) isn't writing anything to slave (monitoring slave))   
  `CARD_SEL` : when address `AI[9:0]`is available and master ready to read SDO[31:0] => '1' / else => '0'  
  `BA[2:0]` : the 3-bit identifier for the slave (explanation above)  
  
  `SACK_N` : goes to '0' for 1 CC when read is finished \ else '1' 
  
  * `CARD_SEL` goes to '1' first, and waits for the `SACK_N` signal to go to '0', then `CARD_SEL` and `SACK_N` both go to '1' on the next CC  


## RAMx32

  Configuration:  
  `Inputs: CLK, WE, d[31:0], add[4:0]`  
  `Outputs: do[31:0]`
  
  Principles:
  * RAM takes in address `add[4:0]` on the rising edge of CLK
  * `do[31:0]` is the output of `RAM[ add [4:0] ]` (`add[4:0]` from above)
  
  `WE` : If '1' at the rising edge of CLK, we will write the data from `d[31:0]` to `RAM[ add[4:0] ]`  
         ~If '0' then don't write
         
         
  Construction of Test Bench:
  Signals `CLK,d[31:0],add[4:0]` are given on the rising edge of `CLK`.
  Signal `WE` has a slight delay
  
  ![Altering 'WE' ](https://raw.githubusercontent.com/mxtsai/year4/master/Computer%20Structures%20Lab/Components/RAM_Runtime-1.jpg)
  
  
## Logic Analyzer

Input : `STEP_EN`, `IN_INIT`, `STOP_N`  
Ouput : `DOUT[31:0]` , `STS[7:0]`

![Image of Logic Analyzer](https://raw.githubusercontent.com/mxtsai/year4/master/Computer%20Structures%20Lab/Components/la.png)  

Notice:   
  1. `cnt_o[4:0]` is still '0' on the falling edge of `in_init` and `step_en`, so writing to RAM starts at address '0'
  2. `STS[7:0]` (STATUS signal) is "000" & `counter[4:0]` concatentated 
  3. In this above example, '10' is being written into RAM[6] (ending of STOP_N)  
  
## Monitoring Slave

Input : 
  * Data : `Monitor_Data[31:0]`, `Input1[31:0]`, `Input2[31:0]`  
  * System :  `CLK`, `STEP_ENAB`, `IN_INITIAL`, `STOPN`   
  * Read Op. : `AI[9:0]`, `CARD_SELECT`, `WRIT_IN`  

Output: `S_DOUT`,`S_ACK_OUT`

![Image of Monitoring Slave](https://raw.githubusercontent.com/mxtsai/year4/master/Computer%20Structures%20Lab/Components/monitor_slave-1.jpg)

The test bench code is [here](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab4/Monitor_Slave_Test.vhd). It is commented with quite some details, and it corresponds with the screeshot above.
