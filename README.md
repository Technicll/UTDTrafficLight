# UTD Traffic Light Controller

Verilog prototype for the CS 4341 digital logic project.
Credits to https://circuitverse.org/simulator

## Project Goal

Design a programmable traffic light controller for:

- Main road lights: North and South
- Side road lights: East and West

Each direction uses 3-bit lamp outputs:

- `3'b100` = Green
- `3'b010` = Yellow
- `3'b001` = Red
- `3'b000` = Off

Control behavior is selected through a 4-bit opcode (`inp_0`) and timing logic.

## Current Progress

The project has moved beyond basic components and now includes integrated control modules and a top-level simulation testbench.

Completed or in-place work:

1. Core sequential building blocks are implemented.
2. Timing modules for main and side roads are implemented.
3. Opcode-based mode selection is implemented (`OP_Selector`).
4. Main and side controllers are integrated in top-level module `Big`.
5. A runnable `TestBench` is included for scenario stepping.

## Recent Changes Made

The following updates were applied to stabilize integration and improve observability:

1. `TestBench` updated to match the expanded `Big` module interface.
2. Named-port instantiation added for `Big` in `TestBench` to avoid port-order mistakes.
3. `Reset` was explicitly added and driven in `TestBench` startup sequence.
4. Additional debug/status outputs from `Big` were wired (left intentionally unconnected in TB where not needed).
5. `Big` internal `OP_Selector` hookup was converted to named-port mapping.
6. `Big` timing signal routing was cleaned so timing mode feeds `Main` and `Side` coherently.
7. Updated the circuit display with posedge
8. Added 7th input to DFlipFlops 
9. Added gitignore so that the current compilations wouldn't take it over

## Module Overview

- `DflipFlop`: Parameterized register primitive (`WIDTH`) with async reset and enable.
- `Counter_2`: 2-bit counter used for phase stepping.
- `Counter6`: 6-bit counter used by timing logic.
- `Multiplexer2`, `Multiplexer4`: Parameterized combinational selectors.
- `RiseEdge_Detector`, `TwoBitRiseEdge`: Edge pulse generators.
- `Main_Timing`, `Side_Timing`: Timing threshold/trigger generators.
- `main_selector`, `Side_selector`: Generate 2-bit color modes.
- `Main`, `Side`: Convert mode codes into 3-bit lamp outputs.
- `OP_Selector`: Maps opcode to directional mode controls, reset, and timing mode.
- `Big`: Top-level integrator for mode selection, light outputs, and debug signals.
- `TestBench`: Drives opcode sequence and prints light outputs over time.

## Testbench Behavior

The current `TestBench` performs:

1. Clock generation (`clk_0`).
2. Reset pulse at startup.
3. Opcode stepping through:
	- `0000`
	- `0001`
	- `0010`
	- `0011`
4. Per-clock console display of North/South/East/West lamp outputs.

## Build and Run

Use Icarus Verilog:

```powershell
iverilog -g2012 -o simv circuits.v
vvp simv
```

## Notes and Known Cleanup Items

There are still style/cleanup opportunities to improve robustness:

1. Some signals in timing modules are assigned more than once (duplicate assign lines).
2. Some modules still use mixed positional and named-port wiring.
3. A final documentation pass for opcode semantics can make testing easier.

## Suggested Next Steps

1. Add a timing table in the README for each opcode mode.
2. Add assertions in `TestBench` for expected light transitions.
3. Normalize all module instantiations to named ports.
4. Remove duplicate continuous assignments and re-verify synthesis/simulation warnings.
