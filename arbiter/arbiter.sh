#!/bin/bash
# using systemc to compile module
g++ -I$SYSTEMC_HOME/include -L$SYSTEMC_HOME/lib-linux64 -o arbiter arbiter.cpp -lsystemc -lm
echo "SystemC Model Output"
./arbiter

echo
# using verilog module and gtkwave
iverilog -o simulation arbiter.v arbiter_tb.v
vvp simulation
gtkwave arbiter.vcd
