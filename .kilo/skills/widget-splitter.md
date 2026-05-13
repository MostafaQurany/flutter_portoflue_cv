# Skill: Atomic Widget Splitter

## Description
Refactors large, monolithic widgets into small, testable atomic components.

## Instructions
Activate this skill if a Widget's `build()` method exceeds 50 lines:
1. **Identify Atoms**: Extract buttons, inputs, and labels to `lib/core/design_system/atoms`.
2. **Identify Molecules**: Extract combined UI (e.g., a labeled input) to `lib/core/design_system/molecules`.
3. **Internal Extraction**: Move complex UI parts into private `_WidgetName` classes within the same file to keep the main `build` method clean.
4. **Const Enforcement**: Ensure all extracted widgets have `const` constructors.