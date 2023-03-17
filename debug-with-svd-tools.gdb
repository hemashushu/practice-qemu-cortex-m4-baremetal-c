# GDB debug config file

target extended-remote localhost:1234
set backtrace limit 32
source svd-tools/gdb-svd.py
svd svd/STM32F405.svd
load
