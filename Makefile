CXX := ~/opt/cross/bin/i686-elf-g++
CPPFLAGS := -std=c++11 -ffreestanding -O2 -Wall -Wextra
CPPFLAGS += -fno-exceptions -nostdlib -fno-rtti

.PHONY: clean

minios.bin: kernel.o linker.ld boot.o
	$(CXX) -T linker.ld -o minios.bin boot.o kernel.o $(CPPFLAGS) -lgcc

kernel.o: kernel.cc
	$(CXX) -c kernel.cc -o kernel.o $(CPPFLAGS)

boot.o: boot.s
	nasm -felf32 boot.s -o boot.o

clean:
	rm kernel.o boot.o minios.bin
