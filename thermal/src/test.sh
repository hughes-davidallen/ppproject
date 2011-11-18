#!/bin/sh

for ((i = 1 ; i < 11; i++))
do
	echo "./thermalPar.exe input_large100.txt 100 false $i"
	./thermalPar.exe input_large100.txt 100 false $i
done
