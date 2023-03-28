#!/bin/bash

arm-none-eabi-gdb main.elf \
    -ex "target extended-remote localhost:1234" \
    -ex "load"

# GDB commands can also be written to a configuration file,
# e.g. "debug.gdb":
#
# ```
# target extended-remote localhost:1234
# set backtrace limit 32
# load
# ```
# and then GDB can be started with the following command:
#
# `$ arm-none-eabi-gdb main.elf -x debug.gdb`
