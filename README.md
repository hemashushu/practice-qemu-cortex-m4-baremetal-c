# QEMU Cortex-M4 bare-metal C

QEMU netduinoplus2:

- ST STM32F405, 168 MHz ARM Cortex-M4 core
- 256 KB Flash
- 192(128+64) KB RAM
- Floating point unit (FPU)

Supported devices:

- ARM Cortex-M3, Cortex M4F
- Analog to Digital Converter (ADC)
- EXTI interrupt
- Serial ports (USART)
- SPI controller
- System configuration (SYSCFG)
- Timer controller (TIMER)

Detail:

- https://qemu.readthedocs.io/en/latest/system/arm/stm32.html
- https://github.com/qemu/qemu/blob/master/include/hw/arm/stm32f405_soc.h
- https://github.com/qemu/qemu/blob/master/hw/arm/stm32f405_soc.c
- https://github.com/qemu/qemu/blob/master/hw/arm/netduinoplus2.c

Define:

```c
#define FLASH_SIZE (1024 * 1024)                // 1024KiB
#define SRAM_SIZE (128 * 1024)                  // 128KiB
#define CCM_SIZE (64 * 1024)                    // 64KiB
#define SYSCLK_FRQ              168000000ULL    // 168MHz
```

## build

`$ ./build.sh`

## run

`$ ./run.sh`

## debug

start QEMU GDB server first:

`$ ./start-gdb-server-qemu.sh`

open another terminal and run:

`$ ./start-gdb-client.sh`

then try to run some GDB commands, e.g.

```gdb
gdb> b _start
gdb> c
gdb> i r
gdb> x/8i $pc
gdb> si
```
