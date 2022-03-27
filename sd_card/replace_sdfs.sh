#!/usr/bin/bash

handle_signals() {
    echo -e "\n Received a signal to exit!\n"
    exit -1
}

trap handle_signals SIGINT SIGSTOP SIGQUIT

# load all fresh binaries
echo "Copying new kernel binary"
cp ../software/linux-socfpga/arch/arm/boot/zImage sdfs/zImage

echo "Copying and refreshing the boot script"
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Awesome bootie" -d boot.script boot.scr
mv boot.scr sdfs/boot.scr

echo "Copying dtb"
cp ../soc_system.dtb sdfs/soc_system.dtb

echo "Copying FPGA rbf"
cp ../soc_system.rbf sdfs/soc_system.rbf

echo "Syncing"
sync

echo "Done"
