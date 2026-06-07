## Brief Description

The single-cycle-processor is composed of 9 separate modules and a top controling module. The 9 separate modules can be divided into three groups:

1. **Datapath Elements:** Includes a 32-bit ALU (`alu`) for `add`, `sub`, `and`, `or`, `addi` operations, two 32-bit Adders (`adder`) for sequential PC incrementing and branch target calculations, several 2-to-1 MUXs (`mux`) for conditional data routing, and an Immediate Generator (`imm_gen`) responsible for immediate number bit processing and sign-extension.
2. **Storage and Memory:** The Register File (`reg_file`) and Data Memory (`data_mem`) are modeled with synchronous write operations (triggered at the positive clock edge) and asynchronous continuous reads to satisfy the single-cycle timing constraints. The Register File enforces the RISC-V specification by hardwiring `x0` to zero. The Instruction Memory (`inst_mem`) functions as an asynchronous ROM, initialized with hardcoded machine code.
3. **Control Logic:** A Control Unit module (`ctr_unit`) decodes the 7-bit opcode to send out control signals to MUXs, memory, and register. An ALU Control module (`alu_control`) decodes the `alu_op` signal alongside specific instruction bits (`funct3` and `inst[30]`) to direct the ALU's specific operational mode.

The top controling module `SingleCycleProcessor` is responsible for connecting all other modules together and forming a complete processor.
## Modules Display

Below are screen shots of simulation results for different modules.

**Register File**

![[Pasted image 20260603170843.png]]

**32-bit ALU**

![[Pasted image 20260603171118.png]]

**32-bit Adder**

![[Pasted image 20260603171300.png]]

**Immediate Generator**

![[Pasted image 20260603171357.png]]

**Control Unit**

![[Pasted image 20260603171449.png]]

**ALU Control**

![[Pasted image 20260603171558.png]]

**2-to-1 MUX**

There are 3 MUXs, from top to below are mux for ALU, mux for PC, and mux for register file written data.

![[Pasted image 20260603171750.png]]

**Instruction Memory**

![[Pasted image 20260603172117.png]]

**Data Memory**

![[Pasted image 20260603172208.png]]

## Instructions Display

**Addi**

![[Pasted image 20260603173112.png]]

The outputs shown in the above figure demonstrate the effect of command `addi t0 x0 -10`. The register `t0`, representing `x5`, accept the addition result of value stored in `x0`, which is 0, and integer -10. Therefore, it's observed that `x(5)` value becomes into `fffffff6`, which is -10 in hexadecimal.

**add**

![[Pasted image 20260603173501.png]]

The outputs shown in the above figure demonstrate the effect of command `add t1 t0 t0`. The register `t1`, representing `x6`, accept the addition result of value stored in `t0` and `t0`, both are -10. Therefore, it's observed that `x(6)` value becomes into `ffffffec`, which is -20 in hexadecimal.

**sub**

![[Pasted image 20260603174614.png]]

The outpus shown in the above figure demostrate the effect of command `sub t2 t0 t1`. Similar to `Add`, `t2` representing register `x7` stores the result of `t0 - t1`, which is -10. Therefore `x7` value becomes `0000000a`, which is -10 in hexadecimal.


**OR**

![[Pasted image 20260603173834.png]]

The outpus shown in the above figure demostrate the effect of command `or t4 t1 t0`. It stores the result of `t1 OR t0`, which is `fffffffe` transformed into hexidecimal, into register t4, which is `x29`. Therefore, it's observed that value of `x29` becomes `fffffffe`.

**AND**
![[Pasted image 20260603174341.png]]

The outpus shown in the above figure demostrate the effect of command `and t3 t1 x0`. Similar to `OR`, stores the result of `t1 AND t0`, which is `00000000` transformed into hexidecimal, into register t3, which is `x28`. Therefore, `x28` remains unchanged. 

**sw**

![[Pasted image 20260603175417.png]]

The outpus shown in the above figure demostrate the effect of command `sw t4 0(x0)`. 
It stores the value stored in register `t4`, which is `x29`, into memory with the address calculated by `0(x0)`, which is still 0. Therefore, it's observed that `Mem[0]` value becomes `fffffffe`, same as `x29`.

**lw**

![[Pasted image 20260603175102.png]]

The outpus shown in the above figure demostrate the effect of command `lw s0 0(x0)`. 
It loads the value stored in memory `[0]`, which is calculated by `0(x0)`, into register `s0`. Therefore, it's observed that `x8(s0)` value becomes `fffffffe`, same as `Mem[0]`.

**beq**

![[Pasted image 20260603180128.png]]

The outpus shown in the above figure demostrate the effect of command `beq s0 s1 L3`. 
If the value stored in `s0` and `s1` are equal, then jump to `L3`. Since it's equal, it's observed that PC jumped to `00000044`, corresponding to `L3`.

## RTL schematic

![[Pasted image 20260603222255.png]]