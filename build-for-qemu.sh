#!/bin/bash

rm main.elf
rm main.bin
rm main.hex

# FPU options
#
# CFLAGS += -mfloat-abi=soft # No FP
# CFLAGS += -mfloat-abi=softfp -mfpu=fpv4-sp-d16 # Soft FP
# CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 # Hard FP
#
# start files and standard libraries
#
# LDFLAGS += -nostartfiles # dont use standard start files
# LDFLAGS += -nodefaultlibs # dont use standard libraries
# LDFLAGS += -nostdlib # dont use startup or default libs

arm-none-eabi-gcc \
    -mcpu=cortex-m4 \
    -mthumb \
    -mfloat-abi=hard \
    -mfpu=fpv4-sp-d16 \
    -DQEMU \
    -Wall \
    -Wextra \
    -g \
    -I vendor-sdk/Drivers/CMSIS/Include \
    -I vendor-sdk/Drivers/CMSIS/Device/ST/STM32F4xx/Include \
    --specs=nosys.specs \
    --specs=nano.specs \
    -nostartfiles \
    -Wl,-T,linker.ld \
    -o main.elf \
    startup.c main.c

# link options:
# -nostartfiles
#   Do not use the standard system startup files when linking. The standard system libraries are used normally, unless -nostdlib, -nolibc, or -nodefaultlibs is used.
# -nodefaultlibs
#   Do not use the standard system libraries when linking. Only the libraries you specify are passed to the linker, and options specifying linkage of the system libraries, such as -static-libgcc or -shared-libgcc, are ignored. The standard startup files are used normally, unless -nostartfiles is used.
# -nostdlib
#   Do not use the standard system startup files or libraries when linking. No startup files and only the libraries you specify are passed to the linker, and options specifying linkage of the system libraries, such as -static-libgcc or -shared-libgcc, are ignored.

arm-none-eabi-size main.elf
arm-none-eabi-objcopy -O binary -S main.elf main.bin
arm-none-eabi-objcopy -O ihex -S main.elf main.hex
