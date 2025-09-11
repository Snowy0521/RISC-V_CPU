// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcpu.h for the primary calling header

#ifndef VERILATED_VCPU___024ROOT_H_
#define VERILATED_VCPU___024ROOT_H_  // guard

#include "verilated.h"


class Vcpu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vcpu___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    CData/*0:0*/ cpu__DOT__reg_write_enable;
    CData/*4:0*/ cpu__DOT__rs1_addr;
    CData/*4:0*/ cpu__DOT__rs2_addr;
    CData/*4:0*/ cpu__DOT__rd_addr;
    CData/*3:0*/ cpu__DOT__alu_control;
    CData/*0:0*/ cpu__DOT__mem_read_enable;
    CData/*0:0*/ cpu__DOT__mem_write_enable;
    CData/*0:0*/ cpu__DOT__branch;
    CData/*0:0*/ cpu__DOT__mem_to_reg;
    CData/*1:0*/ cpu__DOT__alu_op;
    CData/*0:0*/ cpu__DOT__alu_src;
    CData/*6:0*/ cpu__DOT__opcode;
    CData/*2:0*/ cpu__DOT__funct3;
    CData/*0:0*/ cpu__DOT__branch_taken;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ cpu__DOT__pc;
    IData/*31:0*/ cpu__DOT__pc_branch;
    IData/*31:0*/ cpu__DOT__pc_next;
    IData/*31:0*/ cpu__DOT__rs1_data;
    IData/*31:0*/ cpu__DOT__rs2_data;
    IData/*31:0*/ cpu__DOT__alu_b;
    IData/*31:0*/ cpu__DOT__alu_result;
    IData/*31:0*/ cpu__DOT__imm;
    IData/*31:0*/ cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ cpu__DOT__reg_file__DOT__i;
    IData/*31:0*/ cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 2048> cpu__DOT__instruction_memory__DOT__mem;
    VlUnpacked<IData/*31:0*/, 32> cpu__DOT__reg_file__DOT__registers;
    VlUnpacked<IData/*31:0*/, 2048> cpu__DOT__data_memory__DOT__mem;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vcpu__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vcpu___024root(Vcpu__Syms* symsp, const char* v__name);
    ~Vcpu___024root();
    VL_UNCOPYABLE(Vcpu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
