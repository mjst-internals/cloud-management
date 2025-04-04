#!/bin/bash
## =================================================================================================
## Description : Small performance test script, special thanks to ChatGPT ;)
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-performance-test-simple.sh
##
## Requirements:
##      - Bash
##      - sysbench
##      - fio
##
## Notes:
##      - Creates a file ~/benchmark-results.txt, so you can compare the results to other runs.
## =================================================================================================
set -euo pipefail

sudo apt update
sudo apt install -y sysbench fio

OUTFILE="~/benchmark-results.txt"
TMPFILE="/tmp/benchmark-disk-test"

echo "Benchmark started $(date)" | tee $OUTFILE

echo -e "\n===== CPU benchmark =====" | tee -a $OUTFILE
sysbench cpu --cpu-max-prime=20000 run | tee -a $OUTFILE

echo -e "\n===== RAM benchmark =====" | tee -a $OUTFILE
sysbench memory --memory-total-size=1G run | tee -a $OUTFILE

echo -e "\n===== Disc benchmark (sysbench) =====" | tee -a $OUTFILE
sysbench fileio --file-total-size=1G prepare
sysbench fileio --file-total-size=1G --file-test-mode=rndrw --time=30 --max-requests=0 --threads=4 run | tee -a $OUTFILE
sysbench fileio cleanup

echo -e "\n===== Disc enchmark (fio) =====" | tee -a $OUTFILE
fio --name=diskbench --size=1G --filename=$TMPFILE --bs=4k --rw=randrw --ioengine=libaio --iodepth=64 --runtime=30 --numjobs=4 --time_based --group_reporting | tee -a $OUTFILE
rm -f $TMPFILE

echo -e "\nBenchmark finished $(date)" | tee -a $OUTFILE
