// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcpu__Syms.h"


VL_ATTR_COLD void Vcpu___024root__trace_init_sub__TOP__0(Vcpu___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_init_sub__TOP__0\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("$rootio", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+64,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("cpu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+64,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+4,0,"pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+5,0,"pc_plus4",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+6,0,"pc_branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+7,0,"pc_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+8,0,"instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+9,0,"reg_write_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+10,0,"rs1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+11,0,"rs2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+12,0,"rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+13,0,"rs1_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+14,0,"rs2_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+15,0,"rd_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+13,0,"alu_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+16,0,"alu_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+17,0,"alu_control",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+18,0,"alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+19,0,"alu_zero",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"mem_read_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"mem_write_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+22,0,"mem_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+23,0,"branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"mem_to_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+25,0,"alu_op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBit(c+26,0,"alu_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+27,0,"imm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+28,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+29,0,"funct3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+30,0,"funct7",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+66,0,"OPCODE_LOAD",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+67,0,"OPCODE_STORE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+68,0,"OPCODE_ARITH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+69,0,"OPCODE_BRANCH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+70,0,"OPCODE_JAL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+71,0,"OPCODE_JALR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+72,0,"OPCODE_LUI",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+73,0,"OPCODE_AUIPC",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+74,0,"OPCODE_R_TYPE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBit(c+31,0,"branch_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("alu_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+13,0,"a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+16,0,"b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+17,0,"alu_control",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+18,0,"result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+19,0,"zero",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+75,0,"ALU_AND",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+76,0,"ALU_OR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+77,0,"ALU_ADD",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+78,0,"ALU_SUB",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+79,0,"ALU_SLT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+80,0,"ALU_NOR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->popPrefix();
    tracep->pushPrefix("data_memory", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+64,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"mem_read",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"mem_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+18,0,"addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+14,0,"wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+22,0,"rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+1,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("instruction_memory", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+64,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"mem_read",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+82,0,"mem_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+4,0,"addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+83,0,"wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+8,0,"rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+2,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("reg_file", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+64,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+9,0,"we",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+10,0,"raddr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+11,0,"raddr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+12,0,"waddr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+15,0,"wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+13,0,"rdata1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+14,0,"rdata2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("registers", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+32+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+3,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vcpu___024root__trace_init_top(Vcpu___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_init_top\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vcpu___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vcpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vcpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vcpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vcpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vcpu___024root__trace_register(Vcpu___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_register\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vcpu___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vcpu___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vcpu___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vcpu___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vcpu___024root__trace_const_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vcpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_const_0\n"); );
    // Init
    Vcpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcpu___024root*>(voidSelf);
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vcpu___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vcpu___024root__trace_const_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_const_0_sub_0\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+66,(3U),7);
    bufp->fullCData(oldp+67,(0x23U),7);
    bufp->fullCData(oldp+68,(0x13U),7);
    bufp->fullCData(oldp+69,(0x63U),7);
    bufp->fullCData(oldp+70,(0x6fU),7);
    bufp->fullCData(oldp+71,(0x67U),7);
    bufp->fullCData(oldp+72,(0x37U),7);
    bufp->fullCData(oldp+73,(0x17U),7);
    bufp->fullCData(oldp+74,(0x33U),7);
    bufp->fullCData(oldp+75,(0U),4);
    bufp->fullCData(oldp+76,(1U),4);
    bufp->fullCData(oldp+77,(2U),4);
    bufp->fullCData(oldp+78,(6U),4);
    bufp->fullCData(oldp+79,(7U),4);
    bufp->fullCData(oldp+80,(0xcU),4);
    bufp->fullBit(oldp+81,(1U));
    bufp->fullBit(oldp+82,(0U));
    bufp->fullIData(oldp+83,(0U),32);
}

VL_ATTR_COLD void Vcpu___024root__trace_full_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vcpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_full_0\n"); );
    // Init
    Vcpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcpu___024root*>(voidSelf);
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vcpu___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vcpu___024root__trace_full_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_full_0_sub_0\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+2,(vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+3,(vlSelfRef.cpu__DOT__reg_file__DOT__i),32);
    bufp->fullIData(oldp+4,(vlSelfRef.cpu__DOT__pc),32);
    bufp->fullIData(oldp+5,(((IData)(4U) + vlSelfRef.cpu__DOT__pc)),32);
    bufp->fullIData(oldp+6,(vlSelfRef.cpu__DOT__pc_branch),32);
    bufp->fullIData(oldp+7,(((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode))
                              ? vlSelfRef.cpu__DOT__pc_branch
                              : ((0x67U == (IData)(vlSelfRef.cpu__DOT__opcode))
                                  ? (0xfffffffeU & 
                                     (vlSelfRef.cpu__DOT__rs1_data 
                                      + vlSelfRef.cpu__DOT__imm))
                                  : ((IData)(vlSelfRef.cpu__DOT__branch_taken)
                                      ? vlSelfRef.cpu__DOT__pc_branch
                                      : ((IData)(4U) 
                                         + vlSelfRef.cpu__DOT__pc))))),32);
    bufp->fullIData(oldp+8,(vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                            [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                        >> 2U))]),32);
    bufp->fullBit(oldp+9,(vlSelfRef.cpu__DOT__reg_write_enable));
    bufp->fullCData(oldp+10,(vlSelfRef.cpu__DOT__rs1_addr),5);
    bufp->fullCData(oldp+11,(vlSelfRef.cpu__DOT__rs2_addr),5);
    bufp->fullCData(oldp+12,(vlSelfRef.cpu__DOT__rd_addr),5);
    bufp->fullIData(oldp+13,(vlSelfRef.cpu__DOT__rs1_data),32);
    bufp->fullIData(oldp+14,(vlSelfRef.cpu__DOT__rs2_data),32);
    bufp->fullIData(oldp+15,((((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode)) 
                               | (0x67U == (IData)(vlSelfRef.cpu__DOT__opcode)))
                               ? ((IData)(4U) + vlSelfRef.cpu__DOT__pc)
                               : ((IData)(vlSelfRef.cpu__DOT__mem_to_reg)
                                   ? ((IData)(vlSelfRef.cpu__DOT__mem_read_enable)
                                       ? vlSelfRef.cpu__DOT__data_memory__DOT__mem
                                      [(0x7ffU & (vlSelfRef.cpu__DOT__alu_result 
                                                  >> 2U))]
                                       : 0U) : vlSelfRef.cpu__DOT__alu_result))),32);
    bufp->fullIData(oldp+16,(vlSelfRef.cpu__DOT__alu_b),32);
    bufp->fullCData(oldp+17,(vlSelfRef.cpu__DOT__alu_control),4);
    bufp->fullIData(oldp+18,(vlSelfRef.cpu__DOT__alu_result),32);
    bufp->fullBit(oldp+19,((0U == vlSelfRef.cpu__DOT__alu_result)));
    bufp->fullBit(oldp+20,(vlSelfRef.cpu__DOT__mem_read_enable));
    bufp->fullBit(oldp+21,(vlSelfRef.cpu__DOT__mem_write_enable));
    bufp->fullIData(oldp+22,(((IData)(vlSelfRef.cpu__DOT__mem_read_enable)
                               ? vlSelfRef.cpu__DOT__data_memory__DOT__mem
                              [(0x7ffU & (vlSelfRef.cpu__DOT__alu_result 
                                          >> 2U))] : 0U)),32);
    bufp->fullBit(oldp+23,(vlSelfRef.cpu__DOT__branch));
    bufp->fullBit(oldp+24,(vlSelfRef.cpu__DOT__mem_to_reg));
    bufp->fullCData(oldp+25,(vlSelfRef.cpu__DOT__alu_op),2);
    bufp->fullBit(oldp+26,(vlSelfRef.cpu__DOT__alu_src));
    bufp->fullIData(oldp+27,(vlSelfRef.cpu__DOT__imm),32);
    bufp->fullCData(oldp+28,(vlSelfRef.cpu__DOT__opcode),7);
    bufp->fullCData(oldp+29,(vlSelfRef.cpu__DOT__funct3),3);
    bufp->fullCData(oldp+30,((vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                              [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                          >> 2U))] 
                              >> 0x19U)),7);
    bufp->fullBit(oldp+31,(vlSelfRef.cpu__DOT__branch_taken));
    bufp->fullIData(oldp+32,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[0]),32);
    bufp->fullIData(oldp+33,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[1]),32);
    bufp->fullIData(oldp+34,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[2]),32);
    bufp->fullIData(oldp+35,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[3]),32);
    bufp->fullIData(oldp+36,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[4]),32);
    bufp->fullIData(oldp+37,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[5]),32);
    bufp->fullIData(oldp+38,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[6]),32);
    bufp->fullIData(oldp+39,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[7]),32);
    bufp->fullIData(oldp+40,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[8]),32);
    bufp->fullIData(oldp+41,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[9]),32);
    bufp->fullIData(oldp+42,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[10]),32);
    bufp->fullIData(oldp+43,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[11]),32);
    bufp->fullIData(oldp+44,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[12]),32);
    bufp->fullIData(oldp+45,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[13]),32);
    bufp->fullIData(oldp+46,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[14]),32);
    bufp->fullIData(oldp+47,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[15]),32);
    bufp->fullIData(oldp+48,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[16]),32);
    bufp->fullIData(oldp+49,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[17]),32);
    bufp->fullIData(oldp+50,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[18]),32);
    bufp->fullIData(oldp+51,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[19]),32);
    bufp->fullIData(oldp+52,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[20]),32);
    bufp->fullIData(oldp+53,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[21]),32);
    bufp->fullIData(oldp+54,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[22]),32);
    bufp->fullIData(oldp+55,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[23]),32);
    bufp->fullIData(oldp+56,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[24]),32);
    bufp->fullIData(oldp+57,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[25]),32);
    bufp->fullIData(oldp+58,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[26]),32);
    bufp->fullIData(oldp+59,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[27]),32);
    bufp->fullIData(oldp+60,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[28]),32);
    bufp->fullIData(oldp+61,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[29]),32);
    bufp->fullIData(oldp+62,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[30]),32);
    bufp->fullIData(oldp+63,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[31]),32);
    bufp->fullBit(oldp+64,(vlSelfRef.clk));
    bufp->fullBit(oldp+65,(vlSelfRef.reset));
}
