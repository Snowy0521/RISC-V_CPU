// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcpu.h for the primary calling header

#include "Vcpu__pch.h"
#include "Vcpu___024root.h"

void Vcpu___024root___eval_act(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_act\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vcpu___024root___nba_sequent__TOP__0(Vcpu___024root* vlSelf);

void Vcpu___024root___eval_nba(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_nba\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vcpu___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
}

extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_hd336c0f9_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_h50cc04ea_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_heb35be44_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_h82060b20_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_hddaa001a_0;
extern const VlUnpacked<CData/*1:0*/, 128> Vcpu__ConstPool__TABLE_h0de217f9_0;
extern const VlUnpacked<CData/*3:0*/, 512> Vcpu__ConstPool__TABLE_h2eb57cab_0;

VL_INLINE_OPT void Vcpu___024root___nba_sequent__TOP__0(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___nba_sequent__TOP__0\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    SData/*8:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*6:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_0;
    __VdfgRegularize_h0dff6736_0_0 = 0;
    IData/*31:0*/ __VdfgRegularize_h0dff6736_0_2;
    __VdfgRegularize_h0dff6736_0_2 = 0;
    CData/*5:0*/ __VdfgRegularize_h0dff6736_0_3;
    __VdfgRegularize_h0dff6736_0_3 = 0;
    IData/*31:0*/ __VdfgRegularize_h0dff6736_0_4;
    __VdfgRegularize_h0dff6736_0_4 = 0;
    IData/*31:0*/ __VdfgRegularize_h0dff6736_0_10;
    __VdfgRegularize_h0dff6736_0_10 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_11;
    __VdfgRegularize_h0dff6736_0_11 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_12;
    __VdfgRegularize_h0dff6736_0_12 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_13;
    __VdfgRegularize_h0dff6736_0_13 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_14;
    __VdfgRegularize_h0dff6736_0_14 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_15;
    __VdfgRegularize_h0dff6736_0_15 = 0;
    CData/*0:0*/ __VdfgRegularize_h0dff6736_0_16;
    __VdfgRegularize_h0dff6736_0_16 = 0;
    IData/*31:0*/ __VdlyVal__cpu__DOT__reg_file__DOT__registers__v0;
    __VdlyVal__cpu__DOT__reg_file__DOT__registers__v0 = 0;
    CData/*4:0*/ __VdlyDim0__cpu__DOT__reg_file__DOT__registers__v0;
    __VdlyDim0__cpu__DOT__reg_file__DOT__registers__v0 = 0;
    CData/*0:0*/ __VdlySet__cpu__DOT__reg_file__DOT__registers__v0;
    __VdlySet__cpu__DOT__reg_file__DOT__registers__v0 = 0;
    IData/*31:0*/ __VdlyVal__cpu__DOT__data_memory__DOT__mem__v0;
    __VdlyVal__cpu__DOT__data_memory__DOT__mem__v0 = 0;
    SData/*10:0*/ __VdlyDim0__cpu__DOT__data_memory__DOT__mem__v0;
    __VdlyDim0__cpu__DOT__data_memory__DOT__mem__v0 = 0;
    CData/*0:0*/ __VdlySet__cpu__DOT__data_memory__DOT__mem__v0;
    __VdlySet__cpu__DOT__data_memory__DOT__mem__v0 = 0;
    // Body
    __VdlySet__cpu__DOT__data_memory__DOT__mem__v0 = 0U;
    __VdlySet__cpu__DOT__reg_file__DOT__registers__v0 = 0U;
    if (vlSelfRef.cpu__DOT__mem_write_enable) {
        __VdlyVal__cpu__DOT__data_memory__DOT__mem__v0 
            = vlSelfRef.cpu__DOT__rs2_data;
        __VdlyDim0__cpu__DOT__data_memory__DOT__mem__v0 
            = (0x7ffU & (vlSelfRef.cpu__DOT__alu_result 
                         >> 2U));
        __VdlySet__cpu__DOT__data_memory__DOT__mem__v0 = 1U;
    }
    if (((IData)(vlSelfRef.cpu__DOT__reg_write_enable) 
         & (0U != (IData)(vlSelfRef.cpu__DOT__rd_addr)))) {
        __VdlyVal__cpu__DOT__reg_file__DOT__registers__v0 
            = (((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode)) 
                | (0x67U == (IData)(vlSelfRef.cpu__DOT__opcode)))
                ? ((IData)(4U) + vlSelfRef.cpu__DOT__pc)
                : ((IData)(vlSelfRef.cpu__DOT__mem_to_reg)
                    ? ((IData)(vlSelfRef.cpu__DOT__mem_read_enable)
                        ? vlSelfRef.cpu__DOT__data_memory__DOT__mem
                       [(0x7ffU & (vlSelfRef.cpu__DOT__alu_result 
                                   >> 2U))] : 0U) : vlSelfRef.cpu__DOT__alu_result));
        __VdlyDim0__cpu__DOT__reg_file__DOT__registers__v0 
            = vlSelfRef.cpu__DOT__rd_addr;
        __VdlySet__cpu__DOT__reg_file__DOT__registers__v0 = 1U;
    }
    if (__VdlySet__cpu__DOT__data_memory__DOT__mem__v0) {
        vlSelfRef.cpu__DOT__data_memory__DOT__mem[__VdlyDim0__cpu__DOT__data_memory__DOT__mem__v0] 
            = __VdlyVal__cpu__DOT__data_memory__DOT__mem__v0;
    }
    if (__VdlySet__cpu__DOT__reg_file__DOT__registers__v0) {
        vlSelfRef.cpu__DOT__reg_file__DOT__registers[__VdlyDim0__cpu__DOT__reg_file__DOT__registers__v0] 
            = __VdlyVal__cpu__DOT__reg_file__DOT__registers__v0;
    }
    vlSelfRef.cpu__DOT__pc = ((IData)(vlSelfRef.reset)
                               ? 0U : vlSelfRef.cpu__DOT__pc_next);
    vlSelfRef.cpu__DOT__funct3 = (7U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                        [(0x7ffU & 
                                          (vlSelfRef.cpu__DOT__pc 
                                           >> 2U))] 
                                        >> 0xcU));
    vlSelfRef.cpu__DOT__rs2_addr = (0x1fU & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 0x14U));
    vlSelfRef.cpu__DOT__rs1_addr = (0x1fU & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 0xfU));
    vlSelfRef.cpu__DOT__rd_addr = (0x1fU & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                            [(0x7ffU 
                                              & (vlSelfRef.cpu__DOT__pc 
                                                 >> 2U))] 
                                            >> 7U));
    __VdfgRegularize_h0dff6736_0_3 = (0x3fU & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                               [(0x7ffU 
                                                 & (vlSelfRef.cpu__DOT__pc 
                                                    >> 2U))] 
                                               >> 0x19U));
    __VdfgRegularize_h0dff6736_0_13 = (1U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 2U));
    __VdfgRegularize_h0dff6736_0_14 = (1U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 3U));
    __VdfgRegularize_h0dff6736_0_15 = (1U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 4U));
    __VdfgRegularize_h0dff6736_0_16 = (1U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 5U));
    vlSelfRef.cpu__DOT__opcode = (0x7fU & vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                  [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                              >> 2U))]);
    __VdfgRegularize_h0dff6736_0_0 = (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                      [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                      >> 0x1fU);
    __VdfgRegularize_h0dff6736_0_11 = (1U & vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                       [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                                   >> 2U))]);
    __VdfgRegularize_h0dff6736_0_12 = (1U & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                             [(0x7ffU 
                                               & (vlSelfRef.cpu__DOT__pc 
                                                  >> 2U))] 
                                             >> 1U));
    vlSelfRef.cpu__DOT__rs2_data = ((0U == (IData)(vlSelfRef.cpu__DOT__rs2_addr))
                                     ? 0U : vlSelfRef.cpu__DOT__reg_file__DOT__registers
                                    [vlSelfRef.cpu__DOT__rs2_addr]);
    vlSelfRef.cpu__DOT__rs1_data = ((0U == (IData)(vlSelfRef.cpu__DOT__rs1_addr))
                                     ? 0U : vlSelfRef.cpu__DOT__reg_file__DOT__registers
                                    [vlSelfRef.cpu__DOT__rs1_addr]);
    __Vtableidx2 = vlSelfRef.cpu__DOT__opcode;
    vlSelfRef.cpu__DOT__alu_src = Vcpu__ConstPool__TABLE_hd336c0f9_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__mem_to_reg = Vcpu__ConstPool__TABLE_h50cc04ea_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__reg_write_enable = Vcpu__ConstPool__TABLE_heb35be44_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__mem_read_enable = Vcpu__ConstPool__TABLE_h50cc04ea_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__mem_write_enable = Vcpu__ConstPool__TABLE_h82060b20_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__branch = Vcpu__ConstPool__TABLE_hddaa001a_0
        [__Vtableidx2];
    vlSelfRef.cpu__DOT__alu_op = Vcpu__ConstPool__TABLE_h0de217f9_0
        [__Vtableidx2];
    if (__VdfgRegularize_h0dff6736_0_12) {
        if (__VdfgRegularize_h0dff6736_0_11) {
            __VdfgRegularize_h0dff6736_0_4 = (0xfffff000U 
                                              & vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                              [(0x7ffU 
                                                & (vlSelfRef.cpu__DOT__pc 
                                                   >> 2U))]);
            __VdfgRegularize_h0dff6736_0_2 = (((- (IData)((IData)(__VdfgRegularize_h0dff6736_0_0))) 
                                               << 0xbU) 
                                              | (0x7ffU 
                                                 & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                    [
                                                    (0x7ffU 
                                                     & (vlSelfRef.cpu__DOT__pc 
                                                        >> 2U))] 
                                                    >> 0x14U)));
        } else {
            __VdfgRegularize_h0dff6736_0_4 = 0U;
            __VdfgRegularize_h0dff6736_0_2 = 0U;
        }
    } else {
        __VdfgRegularize_h0dff6736_0_4 = 0U;
        __VdfgRegularize_h0dff6736_0_2 = 0U;
    }
    __Vtableidx1 = ((((0x20U == (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                 [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                             >> 2U))] 
                                 >> 0x19U)) ? 6U : 2U) 
                     << 5U) | (((IData)(vlSelfRef.cpu__DOT__funct3) 
                                << 2U) | (IData)(vlSelfRef.cpu__DOT__alu_op)));
    vlSelfRef.cpu__DOT__alu_control = Vcpu__ConstPool__TABLE_h2eb57cab_0
        [__Vtableidx1];
    vlSelfRef.cpu__DOT__imm = ((0x40U & vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                [(0x7ffU & (vlSelfRef.cpu__DOT__pc 
                                            >> 2U))])
                                ? ((IData)(__VdfgRegularize_h0dff6736_0_16)
                                    ? ((IData)(__VdfgRegularize_h0dff6736_0_15)
                                        ? 0U : ((IData)(__VdfgRegularize_h0dff6736_0_14)
                                                 ? 
                                                ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                  ? 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_12)
                                                   ? 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_11)
                                                    ? 
                                                   (((- (IData)((IData)(__VdfgRegularize_h0dff6736_0_0))) 
                                                     << 0x14U) 
                                                    | (((0xff000U 
                                                         & vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                         [
                                                         (0x7ffU 
                                                          & (vlSelfRef.cpu__DOT__pc 
                                                             >> 2U))]) 
                                                        | (0x800U 
                                                           & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                              [
                                                              (0x7ffU 
                                                               & (vlSelfRef.cpu__DOT__pc 
                                                                  >> 2U))] 
                                                              >> 9U))) 
                                                       | (0x7feU 
                                                          & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                             [
                                                             (0x7ffU 
                                                              & (vlSelfRef.cpu__DOT__pc 
                                                                 >> 2U))] 
                                                             >> 0x14U))))
                                                    : 0U)
                                                   : 0U)
                                                  : 0U)
                                                 : 
                                                ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                  ? __VdfgRegularize_h0dff6736_0_2
                                                  : 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_12)
                                                   ? 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_11)
                                                    ? 
                                                   (((- (IData)((IData)(__VdfgRegularize_h0dff6736_0_0))) 
                                                     << 0xcU) 
                                                    | ((0x800U 
                                                        & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                           [
                                                           (0x7ffU 
                                                            & (vlSelfRef.cpu__DOT__pc 
                                                               >> 2U))] 
                                                           << 4U)) 
                                                       | (((IData)(__VdfgRegularize_h0dff6736_0_3) 
                                                           << 5U) 
                                                          | (0x1eU 
                                                             & (vlSelfRef.cpu__DOT__instruction_memory__DOT__mem
                                                                [
                                                                (0x7ffU 
                                                                 & (vlSelfRef.cpu__DOT__pc 
                                                                    >> 2U))] 
                                                                >> 7U)))))
                                                    : 0U)
                                                   : 0U))))
                                    : 0U) : ((IData)(__VdfgRegularize_h0dff6736_0_16)
                                              ? ((IData)(__VdfgRegularize_h0dff6736_0_15)
                                                  ? 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_14)
                                                   ? 0U
                                                   : 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                    ? __VdfgRegularize_h0dff6736_0_4
                                                    : 0U))
                                                  : 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_14)
                                                   ? 0U
                                                   : 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                    ? 0U
                                                    : 
                                                   ((IData)(__VdfgRegularize_h0dff6736_0_12)
                                                     ? 
                                                    ((IData)(__VdfgRegularize_h0dff6736_0_11)
                                                      ? 
                                                     (((- (IData)((IData)(__VdfgRegularize_h0dff6736_0_0))) 
                                                       << 0xbU) 
                                                      | (((IData)(__VdfgRegularize_h0dff6736_0_3) 
                                                          << 5U) 
                                                         | (IData)(vlSelfRef.cpu__DOT__rd_addr)))
                                                      : 0U)
                                                     : 0U))))
                                              : ((IData)(__VdfgRegularize_h0dff6736_0_15)
                                                  ? 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_14)
                                                   ? 0U
                                                   : 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                    ? __VdfgRegularize_h0dff6736_0_4
                                                    : __VdfgRegularize_h0dff6736_0_2))
                                                  : 
                                                 ((IData)(__VdfgRegularize_h0dff6736_0_14)
                                                   ? 0U
                                                   : 
                                                  ((IData)(__VdfgRegularize_h0dff6736_0_13)
                                                    ? 0U
                                                    : __VdfgRegularize_h0dff6736_0_2)))));
    vlSelfRef.cpu__DOT__pc_branch = (vlSelfRef.cpu__DOT__imm 
                                     + vlSelfRef.cpu__DOT__pc);
    vlSelfRef.cpu__DOT__alu_b = ((IData)(vlSelfRef.cpu__DOT__alu_src)
                                  ? vlSelfRef.cpu__DOT__imm
                                  : vlSelfRef.cpu__DOT__rs2_data);
    __VdfgRegularize_h0dff6736_0_10 = (vlSelfRef.cpu__DOT__rs1_data 
                                       | vlSelfRef.cpu__DOT__alu_b);
    vlSelfRef.cpu__DOT__alu_result = ((8U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                       ? ((4U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                           ? ((2U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                               ? 0U
                                               : ((1U 
                                                   & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                                   ? 0U
                                                   : 
                                                  (~ __VdfgRegularize_h0dff6736_0_10)))
                                           : 0U) : 
                                      ((4U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                        ? ((2U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                            ? ((1U 
                                                & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                                ? (
                                                   (vlSelfRef.cpu__DOT__rs1_data 
                                                    < vlSelfRef.cpu__DOT__alu_b)
                                                    ? 1U
                                                    : 0U)
                                                : (vlSelfRef.cpu__DOT__rs1_data 
                                                   - vlSelfRef.cpu__DOT__alu_b))
                                            : 0U) : 
                                       ((2U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                         ? ((1U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                             ? 0U : 
                                            (vlSelfRef.cpu__DOT__rs1_data 
                                             + vlSelfRef.cpu__DOT__alu_b))
                                         : ((1U & (IData)(vlSelfRef.cpu__DOT__alu_control))
                                             ? __VdfgRegularize_h0dff6736_0_10
                                             : (vlSelfRef.cpu__DOT__rs1_data 
                                                & vlSelfRef.cpu__DOT__alu_b)))));
    vlSelfRef.cpu__DOT__branch_taken = 0U;
    if (vlSelfRef.cpu__DOT__branch) {
        vlSelfRef.cpu__DOT__branch_taken = ((4U & (IData)(vlSelfRef.cpu__DOT__funct3))
                                             ? ((1U 
                                                 & (~ 
                                                    ((IData)(vlSelfRef.cpu__DOT__funct3) 
                                                     >> 1U))) 
                                                && (1U 
                                                    & ((1U 
                                                        & (IData)(vlSelfRef.cpu__DOT__funct3))
                                                        ? 
                                                       ((0U 
                                                         == vlSelfRef.cpu__DOT__alu_result) 
                                                        | (~ 
                                                           (vlSelfRef.cpu__DOT__alu_result 
                                                            >> 0x1fU)))
                                                        : 
                                                       (vlSelfRef.cpu__DOT__alu_result 
                                                        >> 0x1fU))))
                                             : ((1U 
                                                 & (~ 
                                                    ((IData)(vlSelfRef.cpu__DOT__funct3) 
                                                     >> 1U))) 
                                                && ((1U 
                                                     & (IData)(vlSelfRef.cpu__DOT__funct3))
                                                     ? 
                                                    (0U 
                                                     != vlSelfRef.cpu__DOT__alu_result)
                                                     : 
                                                    (0U 
                                                     == vlSelfRef.cpu__DOT__alu_result))));
    }
    vlSelfRef.cpu__DOT__pc_next = ((0x6fU == (IData)(vlSelfRef.cpu__DOT__opcode))
                                    ? vlSelfRef.cpu__DOT__pc_branch
                                    : ((0x67U == (IData)(vlSelfRef.cpu__DOT__opcode))
                                        ? (0xfffffffeU 
                                           & (vlSelfRef.cpu__DOT__rs1_data 
                                              + vlSelfRef.cpu__DOT__imm))
                                        : ((IData)(vlSelfRef.cpu__DOT__branch_taken)
                                            ? vlSelfRef.cpu__DOT__pc_branch
                                            : ((IData)(4U) 
                                               + vlSelfRef.cpu__DOT__pc))));
}

void Vcpu___024root___eval_triggers__act(Vcpu___024root* vlSelf);

bool Vcpu___024root___eval_phase__act(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_phase__act\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vcpu___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vcpu___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vcpu___024root___eval_phase__nba(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_phase__nba\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vcpu___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__nba(Vcpu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__act(Vcpu___024root* vlSelf);
#endif  // VL_DEBUG

void Vcpu___024root___eval(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vcpu___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("src/cpu.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vcpu___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("src/cpu.v", 1, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vcpu___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vcpu___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vcpu___024root___eval_debug_assertions(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_debug_assertions\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY(((vlSelfRef.reset & 0xfeU)))) {
        Verilated::overWidthError("reset");}
}
#endif  // VL_DEBUG
