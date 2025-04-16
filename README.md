# DFT_Internship

## Overview

This repository is dedicated to exploring and implementing Design for Test (DFT) techniques. Currently, the project is in its initial stages, focusing on building a solid foundation by learning essential prerequisites.

## Current Status

As of now, the primary focus has been on acquiring the fundamental skills necessary for DFT. This includes:

* **UNIX Command Line Proficiency:**  
  Learning and practicing essential UNIX commands to navigate the file system, manipulate files, and manage processes.

* **Learning TCL Scripting and Command Line Perl:**  
  Developing skills in TCL scripting for automation of EDA tool flows and mastering command line Perl for text processing and automation tasks. Also focusing on regular expressions for pattern matching and data extraction.

* **Synthesis with Cadence Genus:**  
  Gaining experience with the Cadence Genus synthesis tool to convert Verilog RTL designs into gate-level netlists.

* **Timing Analysis with Tempus:**  
  Understanding and performing static timing analysis using the Tempus tool to verify that the design meets timing constraints. This involves analyzing setup(the minimum time data must be stable before clock edge) and hold times(the minimum time data must remain stable after clock edge) , slack, and timing violations to ensure reliable operation at the target clock frequency.

* **Basic Knowledge of Faults:**  
  Studying different types of faults (stuck-at, transition, bridging, etc.) that DFT techniques are designed to detect, enabling effective test pattern generation and fault coverage analysis.

* **Clock Gating and Switching Power:**  
  Learning about clock gating techniques used to reduce dynamic power consumption by disabling clocks to idle modules. Understanding how clock gating affects switching activity and power optimization in designs. Learning about Integrated Clock Gating (ICG) cells that integrate clock gating functionality within standard cells to optimize power and area, and their impact on DFT and timing.

* **Lock-Up Latch:**  
  Understanding the concept of lock-up latches, which are used in clock gating cells to hold data stable during gated clock transitions, preventing data corruption.

* **Shadow Logic:**  
  Studying shadow logic, an unintended logic duplication that can occur during DFT insertion, potentially causing functional or test issues, and learning how to identify and mitigate it.

* **Scan Chain Balancing:**  
  Gaining knowledge about scan chain design and balancing techniques to ensure uniform chain lengths, reduce test time, and improve test quality.

* **Basics of MBIST (Memory Built-In Self-Test):**  
  Acquiring a foundational understanding of MBIST, a DFT technique that embeds self-test logic within memory blocks to facilitate efficient testing of on-chip memories.

## Synthesis Experiments

Two synthesis projects have been initiated to understand the synthesis process:

1.  **MCRB (Memory Controller Redundancy Block):** This project involves synthesizing an RTL description of a Memory Controller Redundancy Block to generate a gate-level netlist. The goal is to understand synthesis flow, timing constraints, and optimization techniques.
2.  **S298 Traffic Light Controller:** This project focuses on synthesizing an RTL model of an S298-based traffic light controller. This provides practical experience in synthesizing a more complex digital system.

## Scan Insertion Process

The scan insertion process requires a gate-level netlist generated from synthesis, a standard-cell library with the necessary views (such as `.mdt`), and a `.do` script to automate the flow.

### MCRB Scan Insertion

Scan insertion was performed on the MCRB gate-level netlist obtained after synthesis. This process involves replacing the standard flip-flops in the synthesized netlist with scan flip-flops (Scan DFF or SDFF). These scan cells are connected serially to form scan chains, enabling controllability and observability for test pattern generation.

### Methodology

- The process is initiated by invoking the scan insertion tool (`Tessent`) with the synthesized gate-level netlist(`mcrb_syn_nangate.v`), standard-cell library (`.mdt`) file, and tool-specific commands provided in the `.do` file.  
- During scan insertion, the tool replaces all regular flip-flops with scan-enabled flip-flops, which include multiplexers to switch between normal functional mode and scan mode.  
- The scan cells are connected in series to form scan chains, allowing serial shifting of test data in and out during test mode.  
- The output of this process is a scan-inserted netlist, which is used for subsequent ATPG (Automatic Test Pattern Generation) and test validation.

### Key Points

- The scan insertion preserves the original functionality of the design while adding testability features.  
- The `.do` file controls the insertion flow, specifying scan chain configurations such as the number of chains, ordering, and clock domains.  
- After scan insertion, the netlist is verified for correctness, and scan chain integrity is checked through gate-level simulations or DFT advisor tools.  
- This step is critical to achieve high fault coverage and enable efficient manufacturing testing.

## Next Steps (DFT Implementation)

The following steps are planned to dive into DFT concepts and implementations:

1.  **Scan Insertion:** Implement scan chain insertion techniques to enhance testability.
2.  **Automatic Test Pattern Generation (ATPG):** Generate test patterns using ATPG tools to detect faults in the design.
3.  **Memory BIST (MBIST):** Implement Memory Built-In Self-Test (MBIST) for testing embedded memories.
4.  **Boundary Scan:** Implement Boundary Scan (IEEE 1149.1) to improve board-level testability.
5.  **Fault Simulation:** Perform fault simulation to evaluate the effectiveness of the generated test patterns.

<!--
## Repository Structure

The repository is organized as follows:

--->
