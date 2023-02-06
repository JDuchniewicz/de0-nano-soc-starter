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

### High-level overview
![image](https://user-images.githubusercontent.com/18423461/217034450-c6b00d01-3826-4766-871a-3cad11b24b1f.png)


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
For the testing purposes, the target needs to be running and be tethered using the Ethernet cable to the host. The `bpfcap_fpga` eXpress Data Path program has to be loaded:
`ip link set dev eth0 xdpgeneric obj simple.o sec simple` where `simple.o` is our XDP program we cross-compiled on host.

From now on it will be capturing the packets to the pre-reserved memory zone accesible from the kernel or any other user of the SDRAM onboard the target board.

Then, some traffic can be put onto the Ethernet link to test if the capturing is working properly:
`ping -s 1024 -c 100 -i 0.2 192.168.2.21` where `-s` regulates the size of packets being sent, `-c` is the number of consecutive packets we would like to dump and `-i` is the interval in seconds to wait between packet transfers. 

To see detailed trace logs with timestamps and debug information be sure to enable the `tracefs` subsystem in kernel:
`mount -t tracefs tracefs /sys/kernel/tracing`

You can view its contents with `cat`:
`cat /sys/kernel/tracing/trace > trace.log`

The power was measured with a regular in-socket power meter, but depending on your needs you might want to use something more accurate.

### Implementation details
The details concerning implementation of the FPGA part can be seen in the [bpcap_fpga](https://github.com/JDuchniewicz/fpga-tcpdump). Similarly, refer to [bpfcap_fpga_sw](https://github.com/JDuchniewicz/fpga-tcpdump-sw) for more information on how patch the kernel drivers and how to compile the software part. Ultimately, the [thesis](https://jduchniewicz.com/FPGA-capture.pdf) contains most complete descriptions about the project.

### Results

