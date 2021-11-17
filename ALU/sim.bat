@echo off

echo sim file is %1 
echo testbench is %2 %3 
echo wave file is %1.vcd

iverilog -o %1 -y ./ %2
vvp -n %1 --lxt2
gtkwave %1.vcd