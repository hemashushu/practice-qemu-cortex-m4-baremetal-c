#!/bin/bash
echo "Note: press <Ctrl+x>, and then press <a> to exit QEMU"
# start gdb server by QEMU
qemu-system-arm -M netduinoplus2 \
    -kernel main.elf \
    -nographic \
    -S \
    -s

# -S: freeze CPU at startup (use 'c' to start execution)
# -s: the same as "-gdb tcp::1234"
