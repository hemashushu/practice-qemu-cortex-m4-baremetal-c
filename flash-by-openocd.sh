#!/bin/bash

# openocd default scripts location "/usr/share/openocd/scripts"

# flash ELF by DAPLINK debugger
 openocd -f interface/cmsis-dap.cfg  -f target/stm32f4x.cfg -c "program main.elf verify reset exit"

# flash ELF by STLINK debugger
# openocd -f interface/stlink.cfg  -f target/stm32f4x.cfg -c "program main.elf verify reset exit"

# flash BIN
#openocd -f interface/cmsis-dap.cfg -f target/stm32f4x.cfg -c "program main.bin verify reset exit 0x08000000"

# NOTE about STM32
# ================
#
# Some firmware/programs (inside the chip) may modify the chip's _Option bytes_ and
# switch on the chip's _Write Protection_, which will cause you to fail to
# flash the new firmware/program into the chip and you will see the following error message:
#
# ```
# Error: stm32x device protected
# Error: failed erasing sectors 0 to 0
# ```
#
# You need to open your chip with `STM32CubeProgrammer` and
# disable the _Write Protection_ in the _Option Bytes_ of the chip
# and click Apply.
# You should also **erase the entire chip's flash**, because the
# firmware/program inside the chip will probably switch on the _Write Protection_
# again after a reboot.