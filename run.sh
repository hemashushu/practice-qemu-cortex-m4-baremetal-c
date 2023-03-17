#!/bin/bash
echo "Note: press <Ctrl+x>, and then press <a> to exit QEMU"
qemu-system-arm -M netduinoplus2 \
    -kernel main.elf \
    -nographic