# Description of Components 

## Master Signals

`Step_En` : will be '1' for one CC when master is about to begin a (set of) instruction \ else '0' (sent from RESA)  
`In_Init` : will be '0' on the falling edge of `Step_En` \ will be '1' one CC after `ACK` signal is sent back from slave \ is '1' when idle (sent from CPU Master to Monitor Slave)  
  
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
  
  | Monitor Slave Input | AI[9:0] (Binary) | AI[9:0] (Hex) | Name (for RESA) |
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
  - stores each cycle of CPU output signals in each "slot" in the Logic Analyzer RAM  

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

# Reading the RESA Output

## Graphic Labels
![Graphic Label Explanation](https://raw.githubusercontent.com/mxtsai/year4/master/Computer%20Structures%20Lab/Components/grap_lab.jpeg)


## Slave Label and Graphic Label Configurations  
```
Label and addresses Report:
CPU RAM Address: 0x40
LA RAM Address: 0x0

Slave Labels:
laram @ 0x0
STATUS @ 0x20
stepnum @ 0x60
regout @ 0x40

Graphic Labels:
ininit @ 0x1f
stepen @ 0x1e
state3 @ 0x3
state2 @ 0x2
state1 @ 0x1
state0 @ 0x0
stepnum4 @ 0x8
stepnum3 @ 0x7
stepnum2 @ 0x6
stepnum1 @ 0x5
stepnum0 @ 0x4
regwrite4 @ 0xd
regwrite3 @ 0xc
regwrite2 @ 0xb
regwrite1 @ 0xa
regwrite0 @ 0x9

Memory Labels:
```
**Explanation:**  
`Label and addresses Report` and `Slave Labels` values are the AI[9:0], which corresponds to the partitioning mentioned above.  
`Graphic Labels` are the indexing within the 32bit string output by `DOUT[31:0]` of the Logic Analyzer.  

## Step Simulation Results
from step 2 of a simulation
```vhdl
Slave Labels:
laram = 0xc000101f
STATUS = 0x0000a115
stepnum = 0x00000002
regout = 0x00000000

Registers:
R0  : 0x00000000 0x01010101 0x02020202 0x03030303
R4  : 0x04040404 0x05050505 0x06060606 0x07070707
R8  : 0x08080808 0x09090909 0x0a0a0a0a 0x0b0b0b0b
R12 : 0x0c0c0c0c 0x0d0d0d0d 0x0e0e0e0e 0x0f0f0f0f
R16 : 0x10101010 0x11111111 0x12121212 0x13131313
R20 : 0x14141414 0x15151515 0x16161616 0x17171717
R24 : 0x00000000 0x00000000 0x00000000 0x00000000
R28 : 0x00000000 0x00000000 0x00000000 0x00000000
```

**Explanation:**  
`laram`: Since we defined the slave label as `laram @ 0x0`, it reads the first 32bit string stored in Logic Analyzer's RAM.   
From above, we set `ininit @ 0x1f` and `stepen @ 0x1e`, so when the CPU first starts, `ininit` and `stepen` are both '1', hence the '`c`' in the first `laram` MSB (Hex) output.  
Since `state` was `f` during the inital stage of the CPU write operation, we get '`f`' on the LSB (Hex) output.
(and then we can examine every bit as given above to determine their values at etc...)  

