# Computer Structures and Operating System [Lab]
*Done with significant guidance from [Leo Katz](mailto:leokatz@mail.tau.ac.il)*

The resources for this lab are available : [http://www.eng.tau.ac.il/~marko/CompLab_f_18I/](http://www.eng.tau.ac.il/~marko/CompLab_f_18I/)

The summary of whatever is going on is [here](https://github.com/mxtsai/year4/tree/master/Computer%20Structures%20Lab/Components).  


## Environment Setup
* Windows 10 
* Xilink ISE Design Suite 14.7 (Win7 version)

## Lab Session Files
### 1. Introduction
  * small example on how to use the design suite : [*decoder_v25.zip*](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab1/decoder_v25.zip)
  * lab work 1 : [*part2_A1.zip*](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab1/part2_A1.zip)
### 2. RESA Bus Interface
  * coded the RESA bus interface in VHDL : [*resa_bus.vhd*](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab2/resa_bus.vhd)
  * timing diagram for read/write/write&read : [*resa_bus.pdf*](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab2/resa_bus.pdf)
  * lab work 2 : [*buses.zip*](https://github.com/mxtsai/year4/blob/master/Computer%20Structures%20Lab/lab2/buses.zip)


### 4. Monitoring Slave (lab 3 included)
  * Came up with the following table for our Monitoring Slave design  
  
  | Monitor Slave Input | Address (Binary) | Name (for RESA) |
  | --- | --- | --- |
  |       in1           |  0x000  |   laram      |
  |       in2           |  0x020  |   STATUS     |
  |       in3           |  0x040  |   regout    |
  |       in4           |  0x060  |   stepnum     |
