#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcpu.h"

#define MAX_SIM_TIME 1000

int sim_time = 0;

int main(int argc, char** argv, char** env){
    Verilated::commandArgs(argc, argv);
    Vcpu* top = new Vcpu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sim.vcd");

    while (sim_time < MAX_SIM_TIME && !Verilated::gotFinish()) {
        bool clk = (sim_time % 10) < 5; // 10 time units clock period
        top->clk = clk;

        // Toggle reset after 100 time units
        top->reset = (sim_time < 100) ? 1 : 0;

        top->eval();
        tfp->dump(sim_time);
        sim_time++;
    }

    tfp->close();
    delete top;
    exit(0);
}