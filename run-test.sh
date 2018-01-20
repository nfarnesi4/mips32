#!/bin/bash

# Simple script to compile and run all testbenches

VHDL_FILE_EXTENSION=.vhd

# make the working directory for all the files ghdl creates
mkdir -p work

# make the directory for the vcd files
mkdir -p results

# show ghdl where all the vhdl files are
ghdl -i --workdir=work *$VHDL_FILE_EXTENSION

# loop through all the testbench files
for f in *_tb.vhd; do

	# remove the file extenstion
	tb_name="${f%$VHDL_FILE_EXTENSION}"

	# make each testbench
	echo
	echo Building $tb_name
	ghdl -m --workdir=work $tb_name

	# run each testbench
	echo
	echo Running $tb_name
	ghdl -r --workdir=work $tb_name --vcd=./results/$tb_name.vcd

	# clean all the ghdl files
	ghdl --clean --workdir=work
done
