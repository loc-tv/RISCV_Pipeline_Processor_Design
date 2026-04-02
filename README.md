# RISC-V 5-Stage Pipeline Processor (Verilog)

## Giới thiệu

Project này triển khai một bộ xử lý **RISC-V 5-stage pipeline** bằng Verilog, bao gồm đầy đủ các giai đoạn:

* IF (Instruction Fetch)
* ID (Instruction Decode)
* EX (Execute)
* MEM (Memory Access)
* WB (Write Back)

Thiết kế hỗ trợ:

* Arithmetic instructions (ADD, SUB, AND, OR, SLT, ...)
* Load/Store (LW, SW)
* Branch (BEQ, ...)
* Forwarding (giảm hazard)

---

## Cấu trúc thư mục

```
project/
│
├── src/
│   ├── Pipeline_top.v          # Top module (kết nối toàn pipeline)
│   ├── Fetch_Cycle.v           # IF stage
│   ├── Decode_Cycle.v          # ID stage
│   ├── Execute_Cycle.v         # EX stage
│   ├── Memory_Cycle.v          # MEM stage
│   ├── Writeback_Cycle.v       # WB stage
│
│   ├── PC.v                    # Program Counter
│   ├── PC_Adder.v              # PC + 4
│   ├── Mux.v                   # MUX (2:1, 3:1)
│
│   ├── Instruction_Memory.v    # Instruction memory (ROM)
│   ├── Data_Memory.v           # Data memory (RAM)
│
│   ├── Register_File.v         # Register file (32 regs)
│   ├── ALU.v                   # ALU
│   ├── ALU_Decoder.v           # ALU control
│   ├── Main_Decoder.v          # Control Unit
│   ├── Sign_Extend.v           # Immediate generator
│
│   ├── Hazard_unit.v           # Forwarding / hazard detection
│
│   └── memfile.hex             # Chương trình test (hex)
│
├── pipeline_tb.v               # Testbench
├── dump.vcd                    # Waveform output
└── README.md                   # Tài liệu project
```

---

## Cách chạy mô phỏng

### 1. Compile

```bash
env -i DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME bash --noprofile --norc
iverilog -o out.vvp src/Pipeline.v pipeline_tb.v
```

### 2. Run simulation

```bash
vvp out.vvp
```

### 3. Xem waveform

```bash
gtkwave dump.vcd
```

---

## Testbench

Testbench (`pipeline_tb.v`) thực hiện:

* Tạo clock
* Reset hệ thống
* Load chương trình từ `memfile.hex`
* In giá trị PC và instruction mỗi chu kỳ
* Dump waveform (`.vcd`)

---

## Lưu ý quan trọng

### 1. Đường dẫn memory

Đảm bảo file `.hex` nằm đúng vị trí:

```verilog
$readmemh("memfile.hex", dut.Fetch.IMEM.mem);
```

---

### 2. Reset

* Reset active LOW (`rst = 0 → reset`)
* Toàn bộ pipeline register cần reset đúng

---

### 3. Tránh lỗi `X` trong waveform

Cần đảm bảo:

* Register File được initialize
* Data Memory được initialize
* Forwarding hoạt động đúng

---

### 4. Addressing

* Instruction/Data memory dùng:

```verilog
mem[A[31:2]]
```

→ word-aligned

---

## Tính năng chính

| Feature          | Trạng thái            |
| ---------------- | --------------------- |
| 5-stage pipeline | ✅                     |
| Forwarding       | ✅                     |
| Hazard handling  | ⚠ (cần kiểm tra thêm) |
| Branch           | ✅                     |
| Load/Store       | ✅                     |

---

## Debug

Nếu gặp lỗi:

* `Unknown module` → thiếu file khi compile
* `X trong waveform` → lỗi reset / init
* `dump.vcd error` → sai path

---

## Hướng phát triển

* Thêm **stall (load-use hazard)**
* Thêm **branch prediction**
* Hỗ trợ **JAL/JALR**
* Mapping lên FPGA

---

## Tool
* Visual studio code 
* gtkwave

