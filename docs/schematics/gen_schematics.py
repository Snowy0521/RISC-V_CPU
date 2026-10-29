"""Generate block-level schematics (SVG) for every module in src/.

Usage: python3 docs/schematics/gen_schematics.py
Writes <module>.svg next to this script. Drawn by hand from the RTL, so
update the matching function here when a module changes.
"""
import os
from xml.sax.saxutils import escape

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

FILL = {
    "comb": ("#e8f1fb", "#3b6ea8"),    # combinational logic
    "seq": ("#fdf0e1", "#b86b16"),     # state: registers / memories
    "ctrl": ("#e9f6ec", "#2f7d43"),    # control / decode
    "hazard": ("#fbe9ea", "#b33a3a"),  # hazard handling
    "pipe": ("#e6e6e6", "#555555"),    # pipeline registers
}
WIRE = {"data": ("#222222", ""), "ctrl": ("#b33a3a", "5,3")}


class Svg:
    def __init__(self, w, h, title, subtitle):
        self.w, self.h = w, h
        self.items = []
        self.text(20, 28, title, size=16, weight="bold", anchor="start")
        self.text(20, 46, subtitle, size=11, color="#555", anchor="start")

    def text(self, x, y, s, size=11, anchor="middle", color="#222", weight="normal", italic=False):
        style = ' font-style="italic"' if italic else ""
        self.items.append(
            f'<text x="{x}" y="{y}" font-size="{size}" text-anchor="{anchor}" fill="{color}" '
            f'font-weight="{weight}"{style}>{escape(s)}</text>')

    def box(self, x, y, w, h, lines, kind="comb", size=11):
        fill, stroke = FILL[kind]
        self.items.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="4" '
                          f'fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>')
        top = y + h / 2 - (len(lines) - 1) * (size + 3) / 2 + size / 3
        for i, line in enumerate(lines):
            self.text(x + w / 2, top + i * (size + 3), line, size=size,
                      weight="bold" if i == 0 else "normal")

    def mux(self, x, y, w, h, inputs, sel=None, sel_below=False):
        """inputs: [(y, label)]; returns output point (right edge, centre)."""
        fill, stroke = FILL["comb"]
        pts = f"{x},{y} {x + w},{y + h * 0.15} {x + w},{y + h * 0.85} {x},{y + h}"
        self.items.append(f'<polygon points="{pts}" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>')
        for iy, label in inputs:
            self.text(x + 3, iy + 3, label, size=9, anchor="start", color="#3b6ea8")
        if sel:
            self.text(x + w / 2, y + h + 12 if sel_below else y - 5, sel, size=10, color="#b33a3a")
        return x + w, y + h / 2

    def wire(self, pts, label=None, at=None, kind="data", arrow=True, anchor="start"):
        color, dash = WIRE[kind]
        d = " ".join(f"{x},{y}" for x, y in pts)
        dash_attr = f' stroke-dasharray="{dash}"' if dash else ""
        marker = f' marker-end="url(#arrow-{kind})"' if arrow else ""
        self.items.append(f'<polyline points="{d}" fill="none" stroke="{color}" '
                          f'stroke-width="1.3"{dash_attr}{marker}/>')
        if label:
            lx, ly = at if at else (pts[0][0] + 4, pts[0][1] - 4)
            self.text(lx, ly, label, size=10, anchor=anchor, color=color)

    def dot(self, x, y):
        self.items.append(f'<circle cx="{x}" cy="{y}" r="2.6" fill="#222"/>')

    def stub(self, x, y, label, kind="data"):
        """Net label: a short wire ending at (x, y) whose source is named, not drawn."""
        self.wire([(x - 22, y), (x, y)], kind=kind)
        self.text(x - 25, y + 3.5, label, size=10, anchor="end", color=WIRE[kind][0])

    def clock(self, x, y):
        """Clock triangle on the bottom edge of a state element."""
        self.items.append(f'<polyline points="{x - 6},{y} {x},{y - 8} {x + 6},{y}" '
                          f'fill="none" stroke="#b86b16" stroke-width="1.3"/>')

    def legend(self, x, y):
        entries = [("comb", "combinational"), ("seq", "state (register / memory)"),
                   ("ctrl", "control / decode"), ("hazard", "hazard handling"),
                   ("pipe", "pipeline register")]
        for i, (kind, label) in enumerate(entries):
            fill, stroke = FILL[kind]
            cx = x + i * 190
            self.items.append(f'<rect x="{cx}" y="{y - 10}" width="16" height="12" rx="2" '
                              f'fill="{fill}" stroke="{stroke}"/>')
            self.text(cx + 22, y, label, size=10, anchor="start")
        self.wire([(x, y + 20), (x + 40, y + 20)])
        self.text(x + 46, y + 24, "data", size=10, anchor="start")
        self.wire([(x + 190, y + 20), (x + 230, y + 20)], kind="ctrl")
        self.text(x + 236, y + 24, "control / hazard signal", size=10, anchor="start")

    def save(self, name):
        markers = "".join(
            f'<marker id="arrow-{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" '
            f'markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{c}"/></marker>'
            for k, (c, _) in WIRE.items())
        body = "\n".join(self.items)
        svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" height="{self.h}" '
               f'viewBox="0 0 {self.w} {self.h}" font-family="Helvetica, Arial, sans-serif">\n'
               f'<defs>{markers}</defs>\n'
               f'<rect width="100%" height="100%" fill="#ffffff"/>\n{body}\n</svg>\n')
        with open(os.path.join(OUT_DIR, name + ".svg"), "w") as f:
            f.write(svg)


# ------------------------------------------------------------------ alu.v
def alu():
    s = Svg(620, 490, "alu (src/alu.v)",
            "32-bit ALU: six operations, result selected by alu_control; zero = (result == 0)")
    ops = [("0000", "AND", "a & b"), ("0001", "OR", "a | b"), ("0010", "ADD", "a + b"),
           ("0110", "SUB", "a - b"), ("0111", "SLT", "(a < b) ? 1 : 0, unsigned"),
           ("1100", "NOR", "~(a | b)")]
    centers = [136 + i * 46 for i in range(len(ops))]
    s.wire([(20, 80), (120, 80)], "a[31:0]", arrow=False)
    s.wire([(20, 100), (140, 100)], "b[31:0]", arrow=False)
    s.wire([(120, 80), (120, centers[-1])], arrow=False)
    s.wire([(140, 100), (140, centers[-1])], arrow=False)
    mux_x, mux_y, mux_h = 400, 90, 330
    for (code, name, expr), cy in zip(ops, centers):
        s.wire([(120, cy), (180, cy)])
        s.dot(120, cy)
        s.dot(140, cy)
        s.box(180, cy - 16, 170, 32, [f"{name}:  {expr}"])
        s.wire([(350, cy), (mux_x, cy)])
    ox, oy = s.mux(mux_x, mux_y, 36, mux_h, [(cy, code) for (code, _, _), cy in zip(ops, centers)])
    s.wire([(418, 450), (418, 397)], "alu_control[3:0]", at=(424, 446), kind="ctrl")
    s.text(446, 410, "other codes -> 0", size=10, anchor="start", color="#555", italic=True)
    s.wire([(ox, oy), (600, oy)], "result[31:0]", at=(500, oy - 5))
    s.dot(480, oy)
    s.wire([(480, oy), (480, 300)])
    s.box(440, 300, 80, 30, ["== 0"])
    s.wire([(520, 315), (600, 315)], "zero", at=(560, 310))
    s.text(20, 478, "Note: SLT compares unsigned; there is no XOR or shift unit (see README, Known Limitations).",
           size=10, anchor="start", color="#555", italic=True)
    s.save("alu")


# ------------------------------------------------------- register_file*.v
def register_file(pipelined):
    name = "register_file_pipelined" if pipelined else "register_file"
    sub = ("32 x 32-bit register file, 2 combinational read ports, 1 synchronous write port"
           + (", same-cycle write-through" if pipelined else ""))
    s = Svg(800, 420, f"{name} (src/{name}.v)", sub)
    s.box(300, 70, 150, 250, ["registers[0:31]", "32 x 32-bit", "", "initial: all 0,", "x2 (sp) = 0x8000"],
          kind="seq")
    s.wire([(20, 100), (300, 100)], "raddr1[4:0]")
    s.wire([(20, 140), (300, 140)], "raddr2[4:0]")
    s.wire([(20, 200), (300, 200)], "waddr[4:0]")
    s.wire([(20, 230), (300, 230)], "wdata[31:0]")
    s.dot(110, 200)
    s.wire([(110, 200), (110, 279), (150, 279)])
    s.wire([(20, 295), (150, 295)], "we", kind="ctrl")
    s.box(150, 270, 120, 34, ["we && waddr != 0"], kind="ctrl", size=10)
    s.wire([(270, 287), (300, 287)], kind="ctrl")
    s.wire([(20, 350), (375, 350), (375, 322)], "clk (write on posedge)")
    s.clock(375, 320)

    for port, base, out_y in ((1, 85, 145), (2, 215, 275)):
        top, bot = base + 20, base + 60
        if pipelined:
            bx, by = s.mux(520, base, 26, 80, [(top, "1"), (bot, "0")], sel=f"wr_hit{port}", sel_below=True)
            s.stub(520, top, "wdata")
            s.wire([(450, bot), (520, bot)])
            s.wire([(bx, by), (585, by), (585, bot), (640, bot)])
        else:
            s.wire([(450, bot), (640, bot)], f"registers[raddr{port}]", at=(460, bot - 4))
        zx, zy = s.mux(640, base, 26, 80, [(top, "1"), (bot, "0")], sel=f"raddr{port} == 0")
        s.stub(640, top, "32'b0")
        s.wire([(zx, zy), (780, zy)], f"rdata{port}[31:0]", at=(700, zy - 5))
    if pipelined:
        s.text(20, 405, "Write-through: wr_hitN = we && waddr == raddrN && waddr != 0; a read of the register being "
               "written returns wdata (covers WB -> ID).", size=10, anchor="start", color="#555", italic=True)
    s.save(name)


# ----------------------------------------------------------- memory*.v
def memory(pipelined):
    name = "memory_pipelined" if pipelined else "memory"
    sub = ("Word-addressed 8 KB memory, combinational read, synchronous write"
           + (", read returns wdata during a write" if pipelined else ""))
    s = Svg(800, 390, f"{name} (src/{name}.v)", sub)
    s.box(280, 70, 180, 220, ["mem[0:2047]", "2048 x 32-bit (8 KB)", "index = addr[12:2]", "",
                              "initial: zero, then", "$readmemh(bin/firmware.img)"], kind="seq", size=10)
    s.wire([(20, 110), (280, 110)], "addr[31:0]")
    s.wire([(20, 190), (280, 190)], "wdata[31:0]")
    s.wire([(20, 240), (280, 240)], "mem_write", kind="ctrl")
    s.wire([(20, 330), (370, 330), (370, 292)], "clk (write on posedge)")
    s.clock(370, 290)
    top, bot = 125, 165
    if pipelined:
        bx, by = s.mux(530, 105, 26, 80, [(top, "1"), (bot, "0")], sel="mem_write", sel_below=True)
        s.stub(530, top, "wdata")
        s.wire([(460, bot), (530, bot)])
        s.wire([(bx, by), (590, by), (590, top), (640, top)])
    else:
        s.wire([(460, top), (640, top)], "mem[addr[12:2]]", at=(470, top - 4))
    zx, zy = s.mux(640, 105, 26, 80, [(top, "1"), (bot, "0")], sel="mem_read")
    s.stub(640, bot, "32'b0")
    s.wire([(zx, zy), (780, zy)], "rdata[31:0]", at=(700, zy - 5))
    s.text(20, 375, "Word accesses only: addr[1:0] and addr[31:13] are ignored (no byte / halfword access).",
           size=10, anchor="start", color="#555", italic=True)
    s.save(name)


# ----------------------------------------------------------------- cpu.v
def cpu():
    D = 220  # datapath sits below the next-PC logic band

    def Y(y):
        return y + D

    s = Svg(1180, 840, "cpu (src/cpu.v)",
            "Single-cycle datapath: every instruction completes in one clock cycle")
    # next-PC logic: pc_next = JAL ? pc_branch : JALR ? jalr_target : (branch_taken ? pc_branch : pc_plus4)
    s.text(20, 72, "Next-PC logic", size=12, weight="bold", anchor="start", color="#555")
    s.box(220, 70, 70, 34, ["pc + 4"])
    s.box(220, 150, 70, 34, ["pc + imm"])
    s.wire([(255, 128), (255, 150)])
    s.text(262, 134, "imm", size=10, anchor="start")
    s.box(250, 195, 150, 34, ["(rs1_data + imm) & ~1"])
    s.wire([(300, 250), (300, 229)])
    s.text(300, 262, "rs1_data", size=10)
    s.wire([(370, 250), (370, 229)])
    s.text(370, 262, "imm", size=10)
    m1x, m1y = s.mux(380, 70, 26, 80, [(87, "0"), (133, "1")], sel="branch_taken")
    s.wire([(290, 87), (380, 87)], "pc_plus4", at=(300, 82))
    s.wire([(290, 167), (460, 167)], "pc_branch", at=(296, 162))
    s.dot(350, 167)
    s.wire([(350, 167), (350, 133), (380, 133)])
    m2x, m2y = s.mux(460, 70, 30, 160, [(110, "*"), (167, "JAL"), (212, "JR")], sel="opcode")
    s.wire([(m1x, 110), (460, 110)])
    s.wire([(400, 212), (460, 212)], "jalr_target", at=(402, 207))
    s.wire([(m2x, m2y), (520, m2y), (520, 275), (110, 275), (110, Y(305)), (130, Y(305))])
    s.text(114, 292, "pc_next", size=10, anchor="start")
    s.text(530, 120, "* = any other opcode", size=10, anchor="start", color="#555", italic=True)
    # PC register and fetch
    s.box(130, Y(280), 50, 50, ["PC", "reset: 0"], kind="seq", size=9)
    s.clock(155, Y(330))
    s.wire([(180, Y(305)), (220, Y(305))], "pc", at=(204, Y(300)))
    s.dot(200, Y(305))
    s.wire([(200, Y(305)), (200, 87), (220, 87)])
    s.dot(200, 167)
    s.wire([(200, 167), (220, 167)])
    s.box(220, Y(260), 120, 90, ["Instruction", "memory", "(memory)"], kind="seq")
    # instruction field bus
    s.wire([(340, Y(305)), (370, Y(305))], "instr", at=(342, Y(300)), arrow=False)
    s.wire([(370, Y(130)), (370, Y(445))], arrow=False)
    s.dot(370, Y(305))
    s.wire([(370, Y(130)), (430, Y(130))], "opcode", at=(374, Y(125)))
    s.wire([(370, Y(270)), (430, Y(270))], "rs1 [19:15]", at=(374, Y(265)))
    s.wire([(370, Y(300)), (430, Y(300))], "rs2 [24:20]", at=(374, Y(295)))
    s.wire([(370, Y(330)), (430, Y(330))], "rd [11:7]", at=(374, Y(325)))
    s.wire([(370, Y(445)), (430, Y(445))])
    # decode
    s.box(430, Y(100), 140, 60, ["Control", "(opcode)"], kind="ctrl")
    for i, sig in enumerate(["alu_src", "alu_op[1:0]", "mem_read", "mem_write", "mem_to_reg", "reg_write",
                             "branch"]):
        s.text(585, Y(96) + i * 13, sig, size=10, anchor="start", color="#b33a3a")
    s.wire([(570, Y(130)), (582, Y(130))], kind="ctrl", arrow=False)
    s.box(430, Y(250), 140, 130, ["Register file", "(register_file)", "", "wdata = rd_data", "we = reg_write"],
          kind="seq")
    s.box(430, Y(420), 140, 50, ["Imm gen", "(by opcode)"])
    # execute
    s.wire([(570, Y(285)), (720, Y(285))], "rs1_data", at=(578, Y(280)))
    s.wire([(570, Y(340)), (640, Y(340))], "rs2_data", at=(574, Y(335)))
    s.wire([(570, Y(445)), (620, Y(445)), (620, Y(380)), (640, Y(380))], "imm", at=(576, Y(440)))
    bx, by = s.mux(640, Y(320), 26, 80, [(Y(340), "0"), (Y(380), "1")], sel="alu_src")
    s.wire([(bx, by), (720, by)])
    s.box(720, Y(260), 80, 120, ["ALU", "(alu)"])
    s.box(690, Y(420), 140, 50, ["ALU control", "(alu_op, funct3,", "funct7)"], kind="ctrl", size=10)
    s.wire([(760, Y(420)), (760, Y(382))], "alu_control", at=(766, Y(405)), kind="ctrl")
    # memory
    s.wire([(800, Y(300)), (880, Y(300))], "alu_result", at=(803, Y(316)))
    s.dot(840, Y(300))
    s.wire([(840, Y(300)), (840, Y(240)), (1050, Y(240)), (1050, Y(290)), (1080, Y(290))])
    s.dot(600, Y(340))
    s.wire([(600, Y(340)), (600, Y(490)), (860, Y(490)), (860, Y(350)), (880, Y(350))], "rs2_data (store data)",
           at=(700, Y(486)))
    s.box(880, Y(260), 110, 120, ["Data memory", "(memory)", "", "mem_read,", "mem_write"], kind="seq")
    s.wire([(800, Y(350)), (850, Y(350)), (850, Y(195)), (880, Y(195))], "zero", at=(806, Y(364)))
    s.box(880, Y(150), 150, 60, ["Branch condition", "(branch, funct3,", "zero, alu_result[31])"],
          kind="ctrl", size=10)
    s.wire([(1030, Y(180)), (1080, Y(180))], "branch_taken", at=(1036, Y(174)), kind="ctrl")
    # write back
    s.wire([(990, Y(325)), (1080, Y(325))], "mem_rdata", at=(994, Y(320)))
    wx, wy = s.mux(1080, Y(270), 28, 110, [(Y(290), "0"), (Y(325), "1"), (Y(360), "J")],
                   sel="mem_to_reg / JAL(R)", sel_below=True)
    s.stub(1080, Y(360), "pc_plus4")
    s.wire([(wx, wy), (1170, wy)], "rd_data", at=(1114, wy - 5))
    s.text(20, Y(520), "BEQ/BNE use the zero flag, BLT/BGE the sign bit of a - b; JAL/JALR write pc_plus4 to rd.",
           size=10, anchor="start", color="#555", italic=True)
    s.legend(20, Y(570))
    s.save("cpu")


# -------------------------------------------------------- cpu_pipelined.v
def cpu_pipelined():
    s = Svg(1500, 780, "cpu_pipelined (src/cpu_pipelined.v)",
            "5-stage pipeline with EX/MEM and MEM/WB forwarding, load-use stall, "
            "jumps resolved in EX and branches resolved in MEM")
    stages = [("IF", 20, 330), ("ID", 375, 640), ("EX", 685, 980), ("MEM", 1025, 1210), ("WB", 1255, 1480)]
    for label, x0, x1 in stages:
        s.text((x0 + x1) / 2, 72, label, size=14, weight="bold", color="#555")
    bars = [("IF/ID", 340, "flush: clear", "stall: hold"),
            ("ID/EX", 650, "flush or stall:", "bubble"),
            ("EX/MEM", 990, "branch taken:", "bubble"),
            ("MEM/WB", 1220, "", "")]
    for label, x, n1, n2 in bars:
        s.box(x, 80, 25, 480, [], kind="pipe")
        s.text(x + 12.5, 95, label, size=9, weight="bold")
        s.text(x + 30, 575, n1, size=9, anchor="start", color="#b33a3a")
        s.text(x + 30, 587, n2, size=9, anchor="start", color="#b33a3a")

    # IF
    nx, ny = s.mux(125, 250, 28, 120, [(270, "1"), (295, "2"), (320, "3"), (345, "4")],
                   sel="priority 1 > 2 > 3 > 4")
    s.stub(125, 270, "ex_mem_pc_branch")
    s.stub(125, 295, "jump_target_ex")
    s.stub(125, 320, "pc (stall)")
    s.stub(125, 345, "pc_plus4")
    s.wire([(nx, ny), (170, ny)])
    s.box(170, 285, 40, 50, ["PC"], kind="seq")
    s.clock(190, 335)
    s.wire([(210, 310), (230, 310)])
    s.dot(220, 310)
    s.wire([(220, 310), (220, 150), (340, 150)], "pc", at=(290, 145))
    s.dot(220, 197)
    s.wire([(220, 197), (230, 197)])
    s.box(230, 180, 60, 34, ["+ 4"])
    s.wire([(290, 197), (340, 197)], "pc_plus4", at=(292, 192))
    s.box(230, 270, 95, 80, ["Instruction", "memory"], kind="seq")
    s.wire([(325, 310), (340, 310)])

    # ID
    s.wire([(365, 125), (420, 125)], "opcode", at=(368, 120))
    s.box(420, 100, 130, 50, ["Control", "(opcode, valid)"], kind="ctrl")
    s.wire([(550, 125), (650, 125)], "ctrl signals", at=(560, 120), kind="ctrl")
    s.wire([(365, 180), (650, 180)], "pc, pc_plus4", at=(560, 175))
    s.wire([(365, 265), (420, 265)], "rs1", at=(370, 260))
    s.wire([(365, 295), (420, 295)], "rs2", at=(370, 290))
    s.box(420, 240, 130, 120, ["Register file", "(write-through)", "", "write port from WB:", "mem_wb_rd_addr,",
                               "rd_data_wb"], kind="seq", size=10)
    s.wire([(550, 250), (650, 250)], "rs1_data", at=(560, 245))
    s.wire([(550, 350), (650, 350)], "rs2_data", at=(560, 345))
    s.wire([(365, 422), (420, 422)])
    s.box(420, 400, 130, 44, ["Imm gen", "(I/S/B/U/J by opcode)"], size=10)
    s.wire([(550, 422), (650, 422)], "imm", at=(560, 417))
    s.wire([(365, 480), (650, 480)], "rs1/rs2/rd addr, funct3, funct7, opcode", at=(370, 475))
    s.box(400, 610, 200, 50, ["Hazard detection (load-use)", "id_ex_mem_read && id_ex_rd in {rs1, rs2}"],
          kind="hazard", size=10)
    s.wire([(400, 635), (352, 635), (352, 562)], kind="ctrl")
    s.dot(352, 635)
    s.wire([(352, 635), (180, 635), (180, 337)], "stall", at=(260, 630), kind="ctrl")
    s.wire([(600, 635), (662, 635), (662, 562)], "stall", at=(610, 630), kind="ctrl")

    # EX
    s.box(700, 98, 170, 46, ["Jump target", "JAL: pc+imm, JALR: (alu_a+imm)&~1"], size=9)
    s.wire([(870, 112), (980, 112)], "jump_target_ex", at=(874, 107))
    s.wire([(870, 132), (980, 132)], "jump_taken_ex", at=(874, 146), kind="ctrl")
    s.box(880, 160, 80, 34, ["pc + imm"])
    s.wire([(960, 177), (990, 177)])
    s.wire([(675, 250), (790, 250)], "id_ex_rs1_data", at=(680, 245))
    s.wire([(675, 350), (790, 350)], "id_ex_rs2_data", at=(680, 345))
    ax, ay = s.mux(790, 235, 26, 75, [(250, "00"), (272, "01"), (294, "10")], sel="forward_a")
    bx, by = s.mux(790, 335, 26, 75, [(350, "00"), (372, "01"), (394, "10")], sel="forward_b")
    s.wire([(ax, 272), (900, 272)], "alu_a", at=(840, 267))
    s.wire([(bx, 372), (850, 372)])
    s.wire([(675, 422), (840, 422), (840, 400), (850, 400)])
    cx, cy = s.mux(850, 357, 24, 58, [(372, "0"), (400, "1")], sel="alu_src", sel_below=True)
    s.wire([(cx, cy), (900, cy)])
    s.box(900, 250, 60, 150, ["ALU"])
    s.box(880, 440, 80, 34, ["ALU ctrl"], kind="ctrl")
    s.wire([(920, 440), (920, 402)], kind="ctrl")
    s.wire([(960, 300), (990, 300)])
    s.wire([(960, 265), (990, 265)], "zero", at=(963, 260))
    s.dot(830, 372)
    s.wire([(830, 372), (830, 500), (990, 500)], "alu_b_fwd (store data)", at=(845, 496))
    s.box(700, 610, 220, 50, ["Forwarding unit", "EX/MEM (10) has priority over MEM/WB (01)"],
          kind="hazard", size=10)
    s.text(810, 676, "-> forward_a / forward_b", size=10, color="#b33a3a")

    # MEM
    s.wire([(1015, 177), (1030, 177), (1030, 100), (1070, 100)])
    s.text(1074, 104, "ex_mem_pc_branch -> PC mux", size=10, anchor="start")
    s.wire([(1015, 265), (1050, 265), (1050, 180), (1070, 180)])
    s.box(1070, 140, 140, 56, ["Branch condition", "(funct3, zero,", "alu_result[31])"], kind="ctrl", size=10)
    s.text(1140, 212, "branch_condition_met", size=10, color="#b33a3a")
    s.text(1140, 224, "-> PC mux, flush", size=10, color="#b33a3a")
    s.wire([(1015, 300), (1070, 300)], "addr", at=(1074, 296))
    s.dot(1055, 300)
    s.wire([(1055, 300), (1055, 245), (1220, 245)], "alu_result", at=(1110, 240))
    s.wire([(1015, 500), (1045, 500), (1045, 350), (1070, 350)])
    s.box(1070, 270, 110, 100, ["Data", "memory"], kind="seq")
    s.wire([(1180, 290), (1220, 290)], "rdata", at=(1184, 285))

    # WB
    wx, wy = s.mux(1320, 230, 28, 120, [(245, "0"), (290, "1"), (330, "J")], sel="mem_to_reg / JAL(R)")
    s.wire([(1245, 245), (1320, 245)])
    s.wire([(1245, 290), (1320, 290)])
    s.stub(1320, 330, "pc_plus4")
    s.wire([(wx, wy), (1470, wy)], "rd_data_wb -> reg file", at=(1352, wy - 5))

    # forwarding paths
    s.dot(1030, 300)
    s.wire([(1030, 300), (1030, 525), (765, 525), (765, 294), (790, 294)])
    s.dot(765, 394)
    s.wire([(765, 394), (790, 394)])
    s.dot(1410, wy)
    s.wire([(1410, wy), (1410, 545), (755, 545), (755, 272), (790, 272)])
    s.dot(755, 372)
    s.wire([(755, 372), (790, 372)])
    s.text(1050, 521, "EX/MEM forwarding", size=10, anchor="start")
    s.text(1050, 541, "MEM/WB forwarding", size=10, anchor="start")

    s.legend(20, 730)
    s.save("cpu_pipelined")


if __name__ == "__main__":
    alu()
    register_file(False)
    register_file(True)
    memory(False)
    memory(True)
    cpu()
    cpu_pipelined()
