# Elevator Controller Verilog Design

This project implements an elevator control system using Verilog HDL.

## Features
- Handles multiple floor requests
- Controls upward and downward movement
- Tracks current floor
- Emergency stop functionality
- Testbench included

## Files
- elevator_controller.v - Design module
- elevator_controller_tb.v - Testbench

## Working
The controller processes floor requests and decides the direction of movement (up/down).
It updates the current floor and stops when the requested floor is reached.

## Tools Used
- Vivado / ModelSim
