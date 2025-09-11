// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcpu__Syms.h"


void Vcpu___024root__trace_chg_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vcpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_chg_0\n"); );
    // Init
    Vcpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcpu___024root*>(voidSelf);
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vcpu___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vcpu___024root__trace_chg_0_sub_0(Vcpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_chg_0_sub_0\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[0U]))) {
        bufp->chgIData(oldp+0,(vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i),32);
        bufp->chgIData(oldp+1,(vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i),32);
        bufp->chgIData(oldp+2,(vlSelfRef.cpu__DOT__reg_file__DOT__i),32);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgIData(oldp+3,(vlSelfRef.cpu__DOT__pc),32);
        bufp->chgIData(oldp+4,(((IData)(4U) + vlSelfRef.cpu__DOT__pc)),32);
        bufp->chgIData(oldp+5,(vlSelfRef.cpu__DOT__pc_branch),32);
        bufp->chgIData(oldp+6,(((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode))
                                 ? vlSelfRef.cpu__DOT__pc_branch
                                 : ((0x67U == (IData)(vlSelfRef.cpu__DOT__opcode))
                                     ? (0xfffffffeU 
                                        & (vlSelfRef.cpu__DOT__rs1_data 
                                           + vlSelfRef.cpu__DOT__imm))
                                     : ((IData)(vlSelfRef.cpu__DOT__branch_taken)
                                         ? vlSelfRef.cpu__DOT__pc_branch
                                         : ((IData)(4U) 
                                            + vlSelfRef.cpu__DOT__pc))))),32);
        bufp->chgIData(oldp+7,(vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                               [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                           >> 2U))]),32);
        bufp->chgBit(oldp+8,(vlSelfRef.cpu__DOT__reg_write_enable));
        bufp->chgCData(oldp+9,(vlSelfRef.cpu__DOT__rs1_addr),5);
        bufp->chgCData(oldp+10,(vlSelfRef.cpu__DOT__rs2_addr),5);
        bufp->chgCData(oldp+11,(vlSelfRef.cpu__DOT__rd_addr),5);
        bufp->chgIData(oldp+12,(vlSelfRef.cpu__DOT__rs1_data),32);
        bufp->chgIData(oldp+13,(vlSelfRef.cpu__DOT__rs2_data),32);
        bufp->chgIData(oldp+14,((((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode)) 
                                  | (0x67U == (IData)(vlSelfRef.cpu__DOT__opcode)))
                                  ? ((IData)(4U) + vlSelfRef.cpu__DOT__pc)
                                  : ((IData)(vlSelfRef.cpu__DOT__mem_to_reg)
                                      ? ((IData)(vlSelfRef.cpu__DOT__mem_read_enable)
                                          ? vlSelfRef.cpu__DOT__data_memory__DOT__mem
                                         [(0x7ffU & 
                                           (vlSelfRef.cpu__DOT__alu_result 
                                            >> 2U))]
                                          : 0U) : vlSelfRef.cpu__DOT__alu_result))),32);
        bufp->chgIData(oldp+15,(vlSelfRef.cpu__DOT__alu_b),32);
        bufp->chgCData(oldp+16,(vlSelfRef.cpu__DOT__alu_control),4);
        bufp->chgIData(oldp+17,(vlSelfRef.cpu__DOT__alu_result),32);
        bufp->chgBit(oldp+18,((0U == vlSelfRef.cpu__DOT__alu_result)));
        bufp->chgBit(oldp+19,(vlSelfRef.cpu__DOT__mem_read_enable));
        bufp->chgBit(oldp+20,(vlSelfRef.cpu__DOT__mem_write_enable));
        bufp->chgIData(oldp+21,(((IData)(vlSelfRef.cpu__DOT__mem_read_enable)
                                  ? vlSelfRef.cpu__DOT__data_memory__DOT__mem
                                 [(0x7ffU & (vlSelfRef.cpu__DOT__alu_result 
                                             >> 2U))]
                                  : 0U)),32);
        bufp->chgBit(oldp+22,(vlSelfRef.cpu__DOT__branch));
        bufp->chgBit(oldp+23,(vlSelfRef.cpu__DOT__mem_to_reg));
        bufp->chgCData(oldp+24,(vlSelfRef.cpu__DOT__alu_op),2);
        bufp->chgBit(oldp+25,(vlSelfRef.cpu__DOT__alu_src));
        bufp->chgIData(oldp+26,(vlSelfRef.cpu__DOT__imm),32);
        bufp->chgCData(oldp+27,(vlSelfRef.cpu__DOT__opcode),7);
        bufp->chgCData(oldp+28,(vlSelfRef.cpu__DOT__funct3),3);
        bufp->chgCData(oldp+29,((vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                 [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                             >> 2U))] 
                                 >> 0x19U)),7);
        bufp->chgBit(oldp+30,(vlSelfRef.cpu__DOT__branch_taken));
        bufp->chgIData(oldp+31,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[0]),32);
        bufp->chgIData(oldp+32,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[1]),32);
        bufp->chgIData(oldp+33,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[2]),32);
        bufp->chgIData(oldp+34,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[3]),32);
        bufp->chgIData(oldp+35,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[4]),32);
        bufp->chgIData(oldp+36,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[5]),32);
        bufp->chgIData(oldp+37,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[6]),32);
        bufp->chgIData(oldp+38,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[7]),32);
        bufp->chgIData(oldp+39,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[8]),32);
        bufp->chgIData(oldp+40,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[9]),32);
        bufp->chgIData(oldp+41,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[10]),32);
        bufp->chgIData(oldp+42,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[11]),32);
        bufp->chgIData(oldp+43,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[12]),32);
        bufp->chgIData(oldp+44,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[13]),32);
        bufp->chgIData(oldp+45,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[14]),32);
        bufp->chgIData(oldp+46,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[15]),32);
        bufp->chgIData(oldp+47,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[16]),32);
        bufp->chgIData(oldp+48,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[17]),32);
        bufp->chgIData(oldp+49,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[18]),32);
        bufp->chgIData(oldp+50,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[19]),32);
        bufp->chgIData(oldp+51,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[20]),32);
        bufp->chgIData(oldp+52,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[21]),32);
        bufp->chgIData(oldp+53,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[22]),32);
        bufp->chgIData(oldp+54,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[23]),32);
        bufp->chgIData(oldp+55,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[24]),32);
        bufp->chgIData(oldp+56,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[25]),32);
        bufp->chgIData(oldp+57,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[26]),32);
        bufp->chgIData(oldp+58,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[27]),32);
        bufp->chgIData(oldp+59,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[28]),32);
        bufp->chgIData(oldp+60,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[29]),32);
        bufp->chgIData(oldp+61,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[30]),32);
        bufp->chgIData(oldp+62,(vlSelfRef.cpu__DOT__reg_file__DOT__registers[31]),32);
    }
    bufp->chgBit(oldp+63,(vlSelfRef.clk));
    bufp->chgBit(oldp+64,(vlSelfRef.reset));
}

void Vcpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root__trace_cleanup\n"); );
    // Init
    Vcpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcpu___024root*>(voidSelf);
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
