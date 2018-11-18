# CPU Design
- covers the general idea behind CPU design rules in our lab 

## I/O Design
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


## Load Store Machine 
  - consists of 2 main parts:  
    **1. Control Module** which consists of *State Control (SC)* and *Memory Address Control (MAC)*  
    **2. Datapath Module**
    
    Input:  `CLK`,`RESET`,`STEP_EN`,`ACK_N`,`DIN[31:0]`  
    Output:  `DOUT[31:0]`,`ADD[31:0]`,`MAC_STATE[1:0]`   
  
### Memory Address Control
in charge of interfacing between the CPU and the `I/O Control Logic`    
    **Input**:  [`CLK`,`MR`,`MW`](CPU > MAC), [`ACK_N`](IO Log > MAC), `RESET`
    **Output**:  [`BUSY`](MAC > CPU), [`AS_N`,`WR_N`](MAC > IO Log), `MAC_STATE[1:0]`(for monitoring)


