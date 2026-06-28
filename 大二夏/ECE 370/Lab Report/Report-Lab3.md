## Brief Description of Modeling

The pipelined processor is composed of several separate modules and a top controlling module. The modules can be divided into four groups:

1. **Datapath Elements:** Includes a 32-bit ALU (`alu`) for arithmetic, logical, and shift operations, an ALU Control module (`alu_control`) for selecting the specific ALU operation, several MUXs for conditional data selection, a PC target generator (`pc_target_gen`) for branch and jump target calculation, and an Immediate Generator (`imm_gen`) for instruction immediate extraction and sign-extension.
2. **Pipeline Registers:** Four pipeline register modules (`if_id_reg`, `id_ex_reg`, `ex_mem_reg`, and `mem_wb_reg`) are inserted between the five pipeline stages. They store both data signals and control signals at each positive clock edge, so that each instruction can move through the IF, ID, EX, MEM, and WB stages correctly.
3. **Storage and Memory:** The Register File (`reg_file`) supports two asynchronous read ports and one synchronous write port, with register `x0` hardwired to zero. The Instruction Memory (`inst_mem`) is modeled as a ROM initialized with machine code. The Data Memory (`data_mem`) supports load and store instructions, including word and byte memory access.
4. **Control Logic:** The Control Unit (`ctr_unit`) decodes the opcode and generates control signals such as `Branch`, `Jal`, `Jalr`, `MemRead`, `MemWrite`, `ALUSrc`, `RegWrite`, `ALUOp`, `WBSel`, `LoadType`, and `StoreType`. The branch condition module (`branch_true`) checks whether a branch condition is satisfied, while the `PCSrc_gen` module determines whether the next PC should select the jump/branch target.

The top controlling module `PipelineProcessor` connects all modules together and forms a complete five-stage pipelined processor.

## Simulation Results 

**Add:**
For the `add` instruction, the simulation at time 80000 shows that `t1` becomes `0x00000326`. Since `t0` already stores `0x00000193`, this confirms that the ALU correctly performs register-register addition and writes the result back to `t1`.
![[Pasted image 20260627162858.png]]

**Addi:**
For the `addi` instruction, the simulation at time 50000 shows that `t0` becomes `0x00000193`. This verifies that the processor correctly adds the sign-extended immediate value to `x0` and writes the result back to the destination register.
![[Pasted image 20260627162842.png]]

**sw:**
For the `sw` instruction, `EX_MEM_MemWrite` becomes high in the MEM stage, indicating a memory write. The signal `EX_MEM_data_read2` provides the data to be stored, which is the value of `t0 = 0xffcd8000`. Therefore, the processor correctly stores one word into data memory

![[Pasted image 20260627164544.png]]

**lw:**
For the `lw` instruction, the simulation at time 680000 shows that `t4` becomes `0xffcd8000`. This value is the same as the value previously stored by `sw t0 0(sp)`, showing that the processor correctly reads a word from data memory and writes it back to the destination register.

![[Pasted image 20260627164655.png]]

**beq:**
For the `beq` instruction, the simulation shows that `t2` becomes `0x00000000` at time 790000. Since `t0` and `t2` are equal before the branch, the branch condition is satisfied and the PC jumps to the `exit` label, where `add t2 x0 x0` is executed.

![[Pasted image 20260627164755.png]]

**jal:**
For the `jal` instruction, the simulation at time 630000 shows that `ra` becomes `0x000000fc`. This confirms that `jal` correctly writes `PC + 4` into the return address register and jumps to the target label `memory_test`.

![[Pasted image 20260627164854.png]]


## RTL Schematic

![[62addf6c9bc6e28469bb5ca49ad51d39.png]]

