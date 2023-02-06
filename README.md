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
The power consumption metric could also be improved by utilizing sleep states in the ARM CPU alongside the FPGA.

### Installation
Clone the project and it's submodules:
`git clone --recurse-submodules` 

Afterwards, create a new project and add all source files from `hardware` directory or use the one attached here. Then, synthesize the project using Quartus IDE and generate the raw bitstream file that will be loaded to the FPGA in the next step.

### Running and testing the project
#### Hardware
Program the board either by using the Quartus IDE programmer, or put the `.rbf` file onto the SD card by using the script `build_makesd.py` located in the `sd_card` folder. This will ensure that the board is programmed during the bootup while in the bootloader phase. Connect the Ethernet cable to ensure network connectivity between host and the target.

#### Software
Software has to be installed in several stages:
* buidling the bootloader
* building the kernel
* building the rootfs and applications

For the kernel and bootloader, the repositories are Altera's forks of original Linux and u-boot bootloaders with Cyclone-V support added.

##### Bootloader
The bootloader is already checked out at the proper tag, but if you are brave then feel free to try it with newer version (I was unable to do so due to missing support for Cyclone V).


##### Kernel
The kernel tested was at 5.15 and probably a newer one will do just as fine as this did - just be careful when applying the patch to stmmmeth driver.

##### Rootfs
Rootfs was built with the Buildroot tool and ultimately the kernel and bootloader builds could be also brought together under one umbrella.



### Testing
For the testing purposes, the target needs to be running and be tethered using the Ethernet cable to the host. The `bpfcap_fpga` Express Data Path program has to be loaded:


### Implementation details
The details concerning implementation of the FPGA part can be seen in the [bpcap_fpga](https://github.com/JDuchniewicz/fpga-tcpdump). Similarly, refer to [bpfcap_fpga_sw](https://github.com/JDuchniewicz/fpga-tcpdump-sw) for more information on how patch the kernel drivers and how to compile the software part. Ultimately, the [thesis](https://jduchniewicz.com/FPGA-capture.pdf) contains most complete descriptions about the project.

### Results


