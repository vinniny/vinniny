# Trieu Thanh Vinh

### Hi, I’m Vinh (he/him)

FPGA/ASIC developer building **digital IP cores** for embedded and edge systems. I focus on high-quality RTL that ships with documentation, reproducible simulations, and CI that proves designs work.

- 🔭 Latest: [QSPI-Flash-Device-Controller](https://github.com/vinniny/QSPI-Flash-Device-Controller)
- 🧰 Tools: Verilator, cocotb, Verible, Icarus, Vivado/Quartus, Gowin
- ✍️ Each flagship repo ships with docs (`docs/`) capturing bring-up notes
- 📫 Reach: LinkedIn • email (replace with your preferred contact details)

## Selected Work

- **QSPI Flash IP** – Timing-safe FSM, flash protocol layer, execute-in-place hooks, Verilator CI.
- **NPU prototypes** – Multi-FPGA partitioning with on-chip DMA and streaming datapaths.
- **CNN/SNN hybrid** – Sparse inference path on FPGA (in progress).

> I like clean RTL, reproducible builds, and CI that actually catches bugs.

## QSPI Flash Controller at a Glance

```
Host (APB/AXI-Lite) --> CSR / Regs --> Command Engine --> QSPI FSM --> Pads
                           |               |                |
                           |               |                `-- IO timing + protocol
                           |               `-- Sequencing, WIP polling
                           `-- DMA / XIP hooks via FIFOs
```

## Featured Repositories

| Repository | Focus |
| --- | --- |
| [QSPI-Flash-Device-Controller](https://github.com/vinniny/QSPI-Flash-Device-Controller) | APB/AXI-Lite bridge to external flash with Verilator and cocotb coverage |
| [OneKiwi_PLC](https://github.com/vinniny/OneKiwi_PLC) | PLC platform experiments with modular HDL blocks |
| [fpga_npu](https://github.com/vinniny/fpga_npu) | Neural processing unit research cores |
| [cnn-snn-hybrid](https://github.com/vinniny/cnn-snn-hybrid) | Bridging CNN feature maps into spiking inference |
| [Embedded-System-Altium](https://github.com/vinniny/Embedded-System-Altium) | Altium project files backing the hardware stack |
| [HK251](https://github.com/vinniny/HK251) | Coursework and experiments that seeded my current toolchain |

## Build & Verification Stack

- Verilator + cocotb (pytest) simulations wired into GitHub Actions.
- Verible linting for SystemVerilog/Verilog style health.
- Linguist overrides ensure HDL is recognized correctly on GitHub.
- CITATION metadata and releases for reproducible artifacts.

## Topics & Tags

Core projects carry topics such as `verilog`, `systemverilog`, `fpga`, `asic`, `apb`, `axi4-lite`, `qspi`, `modbus`, `cocotb`, and `verilator`—making them easier to discover.

## Getting Involved

If you build on any of these IP blocks or tooling, feel free to open a discussion or reach out. I’m always interested in collaborations around FPGA/ASIC verification, embedded integration, and high-confidence hardware builds.
