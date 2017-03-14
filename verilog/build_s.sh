#! /bin/sh
# change -o0 to -o2 for better compiler optimization
riscv32-unknown-elf-gcc -Wall -O0 rand.S -nostdlib -T link.ld -o app.elf
riscv32-unknown-elf-objcopy -O verilog app.elf app.v
riscv32-unknown-elf-objcopy -O binary app.elf app.bin
riscv32-unknown-elf-objdump -d app.elf > app.s
