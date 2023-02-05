# De0-Nano SoC Starter Kit
## Starter repository for *"FPGA accelerated tcpdump with eBPF"* project for my MSc in Embedded Systems.
---

This repository is a parent repository that is further split into two smaller ones:
* [bpfcap_fpga_sw](https://github.com/JDuchniewicz/fpga-tcpdump-sw) - containing Linux kernel patches, `.pcap` dumping program and capture cleaning scripts
* [bpcap_fpga](https://github.com/JDuchniewicz/fpga-tcpdump) - containing RTL code in SystemVerilog for capturing packets using Avalon MM protocol

The full paper is available [here](https://jduchniewicz.com/FPGA-capture.pdf).

---

### Disclaimer
This project has been tested with Quartus 19.1 IDE version as subsequent versions seem to be removing support for Cyclone V SoC family. Feel free to test if you are able to synthesize it with them though.\
Also, I was not able to get the FPGA2SDRAM bridge running using 2 FPGA2HPS bridges (one for sending one for receiving) resulting in maximum bus width of 128 instead of 256 bits.
The power consumption metric gathering could also be improved with utilizing sleep states in the ARM CPU alongside the FPGA.

### Installation


