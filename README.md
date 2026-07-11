# FIFO-Based UART Communication System using Verilog HDL

## About the Project

This project implements a FIFO-Based UART Communication System in Verilog HDL. The main objective of this project is to achieve reliable serial communication by using a FIFO buffer along with a UART transmitter.

UART is widely used in embedded systems and FPGA designs for serial communication. Since UART can transmit only one bit at a time, incoming data may be lost if new data arrives while the transmitter is busy. To overcome this problem, a FIFO buffer is added before the UART transmitter.

The FIFO temporarily stores the incoming data and sends it to the UART whenever the transmitter becomes free. This ensures that the data is transmitted in the correct order without any loss.

---

## What is UART?

UART (Universal Asynchronous Receiver Transmitter) is a serial communication protocol that transfers data between two devices using only two communication lines:

- TX (Transmit)
- RX (Receive)

UART sends data one bit at a time and is commonly used in:

- FPGA to PC communication
- Microcontrollers
- Bluetooth modules
- GPS modules
- Serial debugging

---

## What is FIFO?

FIFO stands for First-In First-Out.

The first data written into the memory is the first data that comes out.

Example:

```
Data Written : 55 -> AA -> F0
Data Read    : 55 -> AA -> F0
```

FIFO acts as a temporary storage buffer between two modules operating at different speeds.

---

## Why is FIFO used with UART?

Suppose UART is transmitting:

```
55
```

Before the transmission is completed, another data arrives:

```
AA
```

Without FIFO, the new data may be lost because UART is still busy.

By using FIFO:

```
55 -> AA -> F0
```

all the incoming data is stored and transmitted one by one without losing any information.

---

## Project Architecture

<p align="center">
  <img src="images/architecture.png" width="900">
</p>

---

## Project Modules

### fifo.v
- 8-bit, 16-depth synchronous FIFO
- Stores incoming data temporarily
- Generates Full and Empty flags

### uart_tx.v
- UART transmitter module
- Adds Start bit and Stop bit
- Converts parallel data into serial data

### uart_fifo_top.v
- Top module integrating FIFO and UART
- Controls data transfer between FIFO and UART

---

## Inputs and Outputs

| Signal | Description |
|---------|-------------|
| clk | System clock |
| rst | Reset signal |
| wr_en | FIFO write enable |
| data_in[7:0] | 8-bit input data |
| tx | UART serial output |
| full | FIFO full flag |
| empty | FIFO empty flag |

---

## Verification

The design was verified in Xilinx Vivado using functional and corner-case testbenches.

### Functional Test Cases
- Reset operation
- Single data transmission
- Multiple data transmission
- FIFO empty condition
- UART transmission

### Corner Test Cases
- Reset during transmission
- Consecutive writes
- Write while UART is busy
- FIFO overflow attempt

---

## Simulation Results

### Functional Waveform

<p align="center">
  <img src="waveforms/functional_waveform.png" width="900">
</p>

### Corner Case Waveform

<p align="center">
  <img src="waveforms/corner_case_waveform.png" width="900">
</p>

---

## Applications

- FPGA communication systems
- Embedded systems
- Serial debugging
- Sensor interfaces
- Data logging applications

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- XSIM Simulator

---

## Skills Learned

- RTL Design
- Verilog Coding
- UART Protocol
- FIFO Design
- Simulation and Verification
- FPGA Development

---

## Author

**Koustubh Shindhe**

B.E. - VLSI Design and Technology
