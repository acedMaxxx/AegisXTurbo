# Aegis-X Turbo: RandomX Integer Accelerator

## How it works
The Aegis-X Turbo is a specialized hardware acceleration block designed to offload the most computationally expensive part of memory-hard hashing algorithms (like RandomX): the **64-bit integer multiplication**. 

While a 1x1 Tiny Tapeout tile lacks the area for the massive scratchpad RAM required for a full RandomX implementation, this chip provides the "brawn" for the virtual machine. It uses a **4-bit nibble-pipelined architecture** to process 64-bit operands. By breaking the 64-bit math into a 16-stage pipeline, the design achieves high clock frequencies (Target: 100MHz) on the 130nm process, providing a significant speedup over software-based multiplication on standard microcontrollers.



## How to test
To use the accelerator:
1. **Initialize:** Pull `rst_n` LOW for 10 cycles to clear the pipeline.
2. **Input Phase:** Feed the 64-bit operands into `ui[3:0]` (4 bits at a time).
3. **Execution:** Pulse `start_pulse` (ui[4]) HIGH. The internal pipeline will begin the 64-bit multiplication and mixing logic.
4. **Output Phase:** After 16-20 clock cycles, the resulting hash fragment/product is available on `uo_out`.
5. **Continuous Mining:** The pipeline can be kept full by feeding new data every cycle after the initial latency, allowing for high-throughput acceleration.

## External hardware
This chip is designed to be used with a host controller (e.g., ESP32, Raspberry Pi Pico, or FPGA). The host manages the memory-hard "Scratchpad" and delegates the heavy 64-bit integer math to the Aegis-X silicon.

## IO Pins

| Pin | Name | Description |
| --- | --- | --- |
| ui[0:3] | data_in | 4-bit Nibble Data Stream (Operands) |
| ui[4] | start | Pulse HIGH to trigger math pipeline |
| ui[5] | mode | Select between Multiplication and XOR-Shift mixing |
| uo[0:7] | hash_out | 8-bit output window of the 64-bit result |

## Technical Specifications
* **Architecture:** Bit-sliced pipelined ALU
* **Data Width:** 64-bit internal registers
* **Throughput:** 1 operation per 16 cycles (initial), 1 per cycle (sustained pipeline)
* **Process:** 130nm (Target 100MHz / 10ns period)
