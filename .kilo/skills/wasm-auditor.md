# Skill: Wasm Compatibility Auditor

## Description
Ensures the codebase is ready for Flutter Web's Wasm (WebAssembly) default.

## Instructions
Review code for the following "Wasm Killers":
1. **Check Imports**: Flags any `dart:html`, `dart:js`, or `dart:io` in shared logic.
2. **Package Update**: Suggest `package:web` instead of legacy JS interop.
3. **Pointer Safety**: Verify that mouse/touch interactions use `Listener` or `Pointer` events for high-fidelity web performance.
4. **Decimal Precision**: Warn if using `int` for values that might exceed JS-safe integer limits in Wasm.