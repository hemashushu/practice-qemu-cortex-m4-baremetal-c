# QEMU Cortex-M4 bare-metal C

QEMU machine _netduinoplus2_:

- STMicroelectronics STM32F405RG, 168 MHz ARM Cortex-M4 core
- 1024 KB Flash
- 192 (128+64) KB RAM
- Floating point unit (FPU)

Details:

- https://qemu.readthedocs.io/en/latest/system/arm/stm32.html
- https://github.com/qemu/qemu/blob/master/include/hw/arm/stm32f405_soc.h
- https://github.com/qemu/qemu/blob/master/hw/arm/stm32f405_soc.c
- https://github.com/qemu/qemu/blob/master/hw/arm/netduinoplus2.c

Some key definitions:

```c
#define FLASH_SIZE  (1024 * 1024)       // 1024KiB
#define SRAM_SIZE   (128 * 1024)        // 128KiB
#define CCM_SIZE    (64 * 1024)         // 64KiB
#define SYSCLK_FRQ  168000000ULL        // 168MHz
```

## Build

`$ ./build-for-qemu.sh`

## Run on QEMU

`$ ./run.sh`

You will see the following output if there is no error:

```text
Ticks: 0
Ticks: 1000
Ticks: 2000
Ticks: 3000
Ticks: 4000
...
```

Press `Ctrl+x` and then press `a` key to exit QEMU.

## Debug on QEMU

Start QEMU GDB server first:

`$ ./start-gdb-server-qemu.sh`

Open another terminal and run the script `start-gdb-client-qemu.sh` or `start-gdb-client-qemu-with-svd-tools.sh` to enter GDB program:

`$ ./start-gdb-client-qemu.sh`

The processor should now halt on the function `Reset_Handler` at `startup.c`, enter the following GDB commands to confirm:

```gdb
(gdb) where
#0  Reset_Handler () at startup.c:28
(gdb) list
...
28          asm("ldr sp, = _estack");
...
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) b main
Breakpoint 1 at 0x8000286: file main.c, line 158.
(gdb) c
Continuing.

Breakpoint 1, main () at main.c:158
158         systick_init();
(gdb) n
159         usart1_init();
(gdb) n
161         char text_prefix[] = "Ticks: ";
```

Enter `q` to exit GDB.

## Debug in the VSCode

Just set a breakpoint on `main.c` and click _VSCode_ side bar `Run and Debug`, then select `Debug (OpenOCD)`.

## Flash on the real STM32F405RG or STM32F4xx

Since the default clock frequency of QEMU and STM32F4xx is different, first recompile the program using the script `build-for-stm32f4xx.sh`.

Then make sure that the STM32F405RG or STM32F4xx is connected to DAPLINK debugger (hardware) via the SWD wires first. If you have _STM32 Nucleo Boards_ or _STM32 Discovery Kits_ with the chip STM32F4xx, just simply use a USB cable to connect it to your computer.

```bash
# flash ELF by DAPLINK debugger
 openocd -f interface/cmsis-dap.cfg  -f target/stm32f4x.cfg -c "program main.elf verify reset exit"

# flash ELF by STLINK debugger
# openocd -f interface/stlink.cfg  -f target/stm32f4x.cfg -c "program main.elf verify reset exit"
```

When the flash is successful, some of the output is shown as below:

```text
Info : auto-selecting first available session transport "swd". To override use 'transport select <transport>'.
Info : CMSIS-DAP: SWD  Supported
Info : CMSIS-DAP: JTAG Supported
Info : CMSIS-DAP: FW Version = 1.10
Info : CMSIS-DAP: Interface Initialised (SWD)
Info : SWCLK/TCK = 1 SWDIO/TMS = 1 TDI = 1 TDO = 1 nTRST = 0 nRESET = 1
Info : CMSIS-DAP: Interface ready
Info : clock speed 2000 kHz
Info : SWD DPIDR 0x2ba01477
Info : stm32f4x.cpu: hardware has 6 breakpoints, 4 watchpoints
Info : starting gdb server for stm32f4x.cpu on 3333
Info : Listening on port 3333 for gdb connections
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x08000044 msp: 0x20020000
Info : High speed (adapter speed 8000) may be limited by adapter firmware.
** Programming Started **
Info : device id = 0x10006431
Info : flash size = 512 kbytes
** Programming Finished **
** Verify Started **
** Verified OK **
** Resetting Target **
shutdown command invoked
```

### Note the STM32 chip's write protection

Some firmware/programs (inside the chip) may modify the chip's _Option bytes_ and switch on the chip's _Write Protection_, which will cause you to fail to flash the new firmware/program into the chip and you will see the following error message:

```text
Error: stm32x device protected
Error: failed erasing sectors 0 to 0
```

You need to open your chip with `STM32CubeProgrammer` and disable the _Write Protection_ in the _Option Bytes_ of the chip
and click Apply.
You should also **erase the entire chip's flash**, because the firmware/program inside the chip will probably switch on the _Write Protection_ again after a reboot.

## View the serial port output

When the flash is successful, open a terminal window and run the following command:

```bash
$ picocom -b 115200 /dev/ttyACM0
```

Where the `ttyACM0` is the serial port number of the Micro:Bit. You can confirm the port number with the command `$ ls /dev/tty` + `<TAB>`.

You will see the output looks like this:

```text
...
Ticks: 1000
Ticks: 2001
Ticks: 3002
Ticks: 4003
Ticks: 5004
Ticks: 6005
Ticks: 7006
Ticks: 8007
Ticks: 9008
...
```

Press `Ctrl+a` then `Ctrl+x` to exit `Picocom` program.

## Debug on real STM32F405RG or STM32F4xx

Start OpenOCD GDB server first:

```bash
# start gdb server by OpenOCD
openocd -f interface/cmsis-dap.cfg  -f target/stm32f4x.cfg -s "/usr/share/openocd/scripts"
```

Open another terminal and run the following commands:

```bash
$ arm-none-eabi-gdb main.elf \
    -ex "target extended-remote localhost:3333" \
    -ex "load"
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) where
#0  Reset_Handler () at startup.c:28
(gdb) b main
Breakpoint 1 at 0x8000286: file main.c, line 158.
Note: automatically using hardware breakpoints for read-only addresses.
(gdb) c
Continuing.

Breakpoint 1, main () at main.c:158
158         systick_init();
(gdb) n
159         usart1_init();
(gdb) n
161         char text_prefix[] = "Ticks: ";
```

Enter `q` to exit GDB.
