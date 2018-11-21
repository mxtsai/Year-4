# General CPU I/O Design
Input:  `CLK`,`RESET`,`STEP_EN`,`ACK_N`,`DIN[31:0]`  
Output:  `DOUT[31:0]`,`ADD[31:0]`  

**Description**:   
`CLK` - the clock signal  
`RESET` - resets the counter inside the CPU and sets CPU to `IDLE` state  
`STEP_EN` - tells CPU's counter to increment  
`ACK_N` - from the slave (through the `IO Logic Control`) to CPU that signals end of current transaction   
`DIN[31:0]` - [only for READ] returns data coming from slave (through the `IO Logic Control`)    
  
`ADD[31:0]` - [READ] the address in `SDRAM` to *read from* | [WRITE] the address in `SDRAM` to *write to*    
`DOUT[31:0]` -  [READ] the data that was just read from `DIN[31:0]`, but outputted during `Loaded` state  | [WRITE] the data that is going to be write into `ADD[31:0]` 


# Load Store Machine 
  - consists of 2 main parts:  
    **1. Control Module** which consists of *State Control (SC)* and *Memory Address Control (MAC)*  
    **2. Datapath Module**
    
    Input:  `CLK`,`RESET`,`STEP_EN`,`ACK_N`,`DIN[31:0]`  
    Output:  `DOUT[31:0]`,`ADD[31:0]`,`MAC_STATE[1:0]`,`ST_CONT_STATE[2:0]`    
  
## Memory Address Control (MAC)
In charge of interfacing between the `State Control` and the `I/O Control Logic`    
  * Input:  [`CLK`,`MR`,`MW`](SC > MAC), [`ACK_N`](IO Log > MAC), `RESET`
  * Internal: `REQ = OR(MR,MW)`  
  * Output:  `BUSY`(MAC > SC), [`AS_N`,`WR_N`,`STOP_N`](MAC > IO Log), `MAC_STATE[1:0]`(for monitoring)  
  
  | States Name | Binary Value | Description |
  |---|---|---|
  |       WAIT4REQ           | 00 | Trigger(enters next state) by internal `REQ` signal |
  |       WAIT4ACK           | 01 | Trigger by signal 'ACK_N' |
  |       NEXT           | 10 | Just one CC after `WAIT4ACK` |

  
  ![image](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/CPU/macsim.jpg?raw=true)
  [Memory Address Control - VHDL](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/CPU/Memory_Access_Machine.vhd)  
  [MAC_Sim Test Bench](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/CPU/MAC_Test.vhd)

## State Control (SC)
Controls the different transition states in the `Load/Store Machine`  
   * Input: []  
   * Ouput: [`pc_ce`,`pc_rst`](SC > PC Env), `add_mux_sel`

## Datapath Module 
Deals with the data IO of the `Load/Store Machine`  
   * Input: [`pc_ce`,`pc_rst`]()
   
### GPR Environment 
  Input: `CLK`,`GPR_WE`,`C_ADR[4:0]`,`A_ADR[4:0]`,`B_ADR[4:0]`,`C[31:0]`  
  Output: `A_OUT[31:0]`,`B_OUT[31:0]`,`D_OUT[31:0]`,`AEQZ`  
  
  ![GPR_Design](https://github.com/mxtsai/Year-4/blob/master/Computer%20Structures%20Lab/CPU/gpr1.jpg?raw=true)
  Notice:
  1. For `C_ADR[4:0] = "00000"`, we have `Register[0]` from the GPR selected. We cannot write into this register as it is reserved for zeros.  
  2. When `GPR_WE=1`, we are writing into `Register[ C_ADR[4:0] ]`, and the value prior to writing will be sent out on from the GPR but since we are writing, the previous value isn't of significance.  
  
