# Flutter 2026 Senior Architecture & Code Standards

## 1. Directory Structure (Feature-First)
Enforce a modular structure. Every feature is a self-contained "mini-app."
- `lib/core/`: Global design system, network clients, and utilities.
- `lib/features/{name}/`: 
    - `domain/`: Entities, Repository Interfaces, Use Cases (Pure Dart).
    - `data/`: DTOs, Repository Impls, Data Sources.
    - `presentation/`: BLoCs/Signals/Providers, Pages, and Widgets.

## 2. State Management & Reactivity
- **Framework**: Use **Riverpod 3.0** for data-binding and **Signals 6.0** for surgical UI updates.
- **Safety**: Async side effects must always be guarded by `if (!context.mounted) return;` or `ref.mounted`.
- **Logic**: Zero business logic in `StatelessWidget`. All logic belongs in a `Notifier` or `Cubit`.

## 3. The "Macro" Standard (No Build_Runner)
- Use **Dart Macros** for serialization and state. 
- Prefer `@JsonCodable` for DTOs and `@Observable` for state classes. 
- Forbid the creation of `.g.dart` or `.freezed.dart` files unless a macro alternative does not exist.

## 4. UI & Performance
- **Atomic Design**: Categorize widgets into Atoms (Core), Molecules (Combined), and Organisms (Feature-specific).
- **Wasm/Impeller**: 
    - No `dart:io` in UI layers; use `package:web` and `package:file`.
    - Use `const` constructors everywhere.
    - Optimize animations for the **Impeller** engine (avoid `Opacity` and `ClipRRect` in lists).

## 5. Security (Zero Trust)
- Secrets must be injected via `--dart-define-from-file`.
- Sensitive data in memory must be cleared after use.
- Enforce SSL Pinning and use `flutter_secure_storage` for tokens.
## Directory Structure: Feature-First Clean Architecture

lib/
├── main.dart                 # App entry & Flavors config
├── app.dart                  # Top-level MaterialApp/Router setup
├── core/                     # Cross-cutting concerns
│   ├── theme/                # Design System (Tokens, Theme Data)
│   ├── router/               # GoRouter/AutoRoute definitions
│   ├── network/              # Dio/Odoo Client wrappers
│   ├── storage/              # SecureStorage/Isar/Hive init
│   ├── constants/            # Enums, App-wide strings
│   ├── utils/                # Extensions, Formatters
│   └── design_system/        # Global Atomic Widgets (Atoms, Molecules)
├── shared/                   # Logic shared across features (but not core)
│   ├── domain/               # Global Entities (e.g., UserEntity)
│   └── presentation/         # Shared Organisms (e.g., AppDrawer)
└── features/                 # Modular functional blocks
    └── {feature_name}/
        ├── domain/           # Business Logic (Pure Dart)
        │   ├── entities/
        │   ├── repositories/ # Interfaces only
        │   └── usecases/
        ├── data/             # Infrastructure (Data layer)
        │   ├── models/       # DTOs + Mappers
        │   ├── repositories/ # Implementations
        │   └── sources/      # Remote (API) & Local (DB)
        └── presentation/     # UI & State
            ├── providers/    # Riverpod/Signals/BLoC logic
            ├── pages/        # Top-level Scaffolded screens
            └── widgets/      # Feature-specific UI components