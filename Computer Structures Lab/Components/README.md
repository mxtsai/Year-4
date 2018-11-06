# Description of Components 

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
  
         
         
  
