#!/bin/bash

# Simple script to compile and run all testbenches

VHDL_FILE_EXTENSION=.vhd

# make the working directory for all the files ghdl creates
mkdir -p work

# make the directory for the vcd files
mkdir -p results

# show ghdl where all the vhdl files are
ghdl -i --workdir=work *$VHDL_FILE_EXTENSION

# create a list of all the tb names and files
TB_FILES=$(find -name "*_tb$VHDL_FILE_EXTENSION" ! -empty)

for f in *_tb.vhd; do
	tb_name="${f%$VHDL_FILE_EXTENSION}"

	echo
	echo Building $tb_name
	ghdl -m --workdir=work $tb_name

	echo
	echo Running $tb_name
	ghdl -r --workdir=work $tb_name --vcd=./results/$tb_name.vcd

	ghdl --clean --workdir=work
done
