# Description of Components 

## RAMx32

  Configuration:  
  `Inputs: CLK, WE, d[31:0], add[4:0]`
  `Outputs: do[31:0]`
  
  Description:  
  `WE` : If '1' at the rising edge of CLK, we will write the data from `d[31:0]` to `RAM[ add[4:0] ]`  
         ~If '0' at the rising edge of CLK, we will output the data from `RAM[ add[4:0] ]` to~
         
         
  
