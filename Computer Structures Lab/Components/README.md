# Description of Components 

## Master Signals

`Step_En` : will be '1' for one CC when master is about to begin a (set of) instruction \ else '0'  
`In_Init` : will be '0' on the falling edge of `Step_En` \ will be '1' one CC after `ACK` signal is sent back from slave \ is '1' when idle  



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
  |       in4           | 0010000000 (=128) |  0x060  |   regwrite      |


## Slave Control
This Slave Control interface is standard for all slaves connected to the BUS.
All slaves share the same `WR_IN_N` and `CARD_SEL` signals, and that's why `BA[2:0]` is needed to differentiate between a master talking to a specific slave.

  Inputs: `BA[2:0]`,`CARD_SEL`,`WR_IN_N`  
  Outputs: `SACK_N`
  
  
  `WR_IN_N` : when master wants to write => '0' / else (including read) => '1'  
              (for master talking to slave monitor, it is always '1' since masters (RESA) isn't writing anything to slave (monitoring slave))   
  `CARD_SEL` : when address `AI[9:0]`is available => '1' / else => '0'  
  `BA[2:0]` : the 3-bit identifier for the slave (explanation above)  
  
  `SACK_N` : goes to '0' for 1 CC when read is finished \ else '1' 


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


  
