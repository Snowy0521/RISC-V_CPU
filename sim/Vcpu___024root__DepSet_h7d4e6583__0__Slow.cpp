// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcpu.h for the primary calling header

#include "Vcpu__pch.h"
#include "Vcpu___024root.h"

VL_ATTR_COLD void Vcpu___024root___eval_static(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_static\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vcpu___024root___eval_initial__TOP(Vcpu___024root* vlSelf);
VL_ATTR_COLD void Vcpu___024root____Vm_traceActivitySetAll(Vcpu___024root* vlSelf);

VL_ATTR_COLD void Vcpu___024root___eval_initial(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_initial\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vcpu___024root___eval_initial__TOP(vlSelf);
    Vcpu___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vcpu___024root___eval_initial__TOP(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_initial__TOP\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlWide<4>/*127:0*/ __Vtemp_2;
    VlWide<4>/*127:0*/ __Vtemp_4;
    // Body
    vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(32, 0x800U, vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i)) {
        vlSelfRef.cpu__DOT__instruction_memory__DOT__mem[(0x7ffU 
                                                          & vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i 
            = ((IData)(1U) + vlSelfRef.cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i);
    }
    __Vtemp_2[0U] = 0x2e696d67U;
    __Vtemp_2[1U] = 0x77617265U;
    __Vtemp_2[2U] = 0x6669726dU;
    __Vtemp_2[3U] = 0x62696e2fU;
    VL_READMEM_N(true, 32, 2048, 0, VL_CVT_PACK_STR_NW(4, __Vtemp_2)
                 ,  &(vlSelfRef.cpu__DOT__instruction_memory__DOT__mem)
                 , 0, ~0ULL);
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[1U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[2U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[3U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[4U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[5U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[6U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[7U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[8U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[9U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xaU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xbU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xcU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xdU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xeU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0xfU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x10U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x11U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x12U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x13U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x14U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x15U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x16U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x17U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x18U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x19U] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1aU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1bU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1cU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1dU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1eU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[0x1fU] = 0U;
    vlSelfRef.cpu__DOT__reg_file__DOT__i = 0x20U;
    vlSelfRef.cpu__DOT__reg_file__DOT__registers[2U] = 0x8000U;
    vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(32, 0x800U, vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i)) {
        vlSelfRef.cpu__DOT__data_memory__DOT__mem[(0x7ffU 
                                                   & vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i 
            = ((IData)(1U) + vlSelfRef.cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i);
    }
    __Vtemp_4[0U] = 0x2e696d67U;
    __Vtemp_4[1U] = 0x77617265U;
    __Vtemp_4[2U] = 0x6669726dU;
    __Vtemp_4[3U] = 0x62696e2fU;
    VL_READMEM_N(true, 32, 2048, 0, VL_CVT_PACK_STR_NW(4, __Vtemp_4)
                 ,  &(vlSelfRef.cpu__DOT__data_memory__DOT__mem)
                 , 0, ~0ULL);
}

VL_ATTR_COLD void Vcpu___024root___eval_final(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_final\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__stl(Vcpu___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vcpu___024root___eval_phase__stl(Vcpu___024root* vlSelf);

VL_ATTR_COLD void Vcpu___024root___eval_settle(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_settle\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vcpu___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("src/cpu.v", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vcpu___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__stl(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___dump_triggers__stl\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcpu___024root___stl_sequent__TOP__0(Vcpu___024root* vlSelf);

VL_ATTR_COLD void Vcpu___024root___eval_stl(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_stl\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vcpu___024root___stl_sequent__TOP__0(vlSelf);
        Vcpu___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_hd336c0f9_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_h50cc04ea_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_heb35be44_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_h82060b20_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vcpu__ConstPool__TABLE_hddaa001a_0;
extern const VlUnpacked<CData/*1:0*/, 128> Vcpu__ConstPool__TABLE_h0de217f9_0;
extern const VlUnpacked<CData/*3:0*/, 512> Vcpu__ConstPool__TABLE_h2eb57cab_0;

VL_ATTR_COLD void Vcpu___024root___stl_sequent__TOP__0(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___stl_sequent__TOP__0\n"); );
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
    // Body
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

VL_ATTR_COLD void Vcpu___024root___eval_triggers__stl(Vcpu___024root* vlSelf);

VL_ATTR_COLD bool Vcpu___024root___eval_phase__stl(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_phase__stl\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vcpu___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vcpu___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__act(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___dump_triggers__act\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__nba(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___dump_triggers__nba\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcpu___024root____Vm_traceActivitySetAll(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root____Vm_traceActivitySetAll\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
}

VL_ATTR_COLD void Vcpu___024root___ctor_var_reset(Vcpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___ctor_var_reset\n"); );
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->reset = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9928399931838511862ull);
    vlSelf->cpu__DOT__pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12979896101630030509ull);
    vlSelf->cpu__DOT__pc_branch = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 2883992461664988269ull);
    vlSelf->cpu__DOT__pc_next = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11401018961025754907ull);
    vlSelf->cpu__DOT__reg_write_enable = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8737831922468932784ull);
    vlSelf->cpu__DOT__rs1_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 4630688813145118729ull);
    vlSelf->cpu__DOT__rs2_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 15754198832867125062ull);
    vlSelf->cpu__DOT__rd_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 13306825634418640529ull);
    vlSelf->cpu__DOT__rs1_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17661784450499594768ull);
    vlSelf->cpu__DOT__rs2_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8728529151167688251ull);
    vlSelf->cpu__DOT__alu_b = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14271438972718572040ull);
    vlSelf->cpu__DOT__alu_control = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 2478348765490579174ull);
    vlSelf->cpu__DOT__alu_result = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12522730548817195188ull);
    vlSelf->cpu__DOT__mem_read_enable = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16580624525018547535ull);
    vlSelf->cpu__DOT__mem_write_enable = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11612777584673328944ull);
    vlSelf->cpu__DOT__branch = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7205763434794021222ull);
    vlSelf->cpu__DOT__mem_to_reg = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10195756977521550306ull);
    vlSelf->cpu__DOT__alu_op = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 10267182419139299418ull);
    vlSelf->cpu__DOT__alu_src = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 720716836299198197ull);
    vlSelf->cpu__DOT__imm = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14334361561440325932ull);
    vlSelf->cpu__DOT__opcode = VL_SCOPED_RAND_RESET_I(7, __VscopeHash, 971283180709441233ull);
    vlSelf->cpu__DOT__funct3 = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 3308832043106885690ull);
    vlSelf->cpu__DOT__branch_taken = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15068204652965702680ull);
    for (int __Vi0 = 0; __Vi0 < 2048; ++__Vi0) {
        vlSelf->cpu__DOT__instruction_memory__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7404162715100081064ull);
    }
    vlSelf->cpu__DOT__instruction_memory__DOT__unnamedblk1__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5787989507557913146ull);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->cpu__DOT__reg_file__DOT__registers[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7942546542290389651ull);
    }
    vlSelf->cpu__DOT__reg_file__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3130395799970134830ull);
    for (int __Vi0 = 0; __Vi0 < 2048; ++__Vi0) {
        vlSelf->cpu__DOT__data_memory__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16394125434072290796ull);
    }
    vlSelf->cpu__DOT__data_memory__DOT__unnamedblk1__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14151692718524899875ull);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9526919608049418986ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
