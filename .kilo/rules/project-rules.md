# Global Project Rules: Flutter Portfolio

These rules apply to all code generated or modified within this repository. Agents must verify compliance before finalizing any output.

## 1. Architectural Integrity
* **Feature-First Structure:** Organize the `lib/` directory by feature (e.g., `lib/features/projects/`, `lib/features/about/`) rather than by type (e.g., avoiding monolithic `lib/screens/` and `lib/widgets/` folders).
* **Separation of Concerns:** UI widgets must not contain direct API calls or business logic. All logic must be handled by the chosen state management solution.

## 2. UI and Styling Constraints
* **Strict Theming:** Never hardcode HEX colors in widgets. All colors must reference the centralized dark theme palette (e.g., `Theme.of(context).colorScheme.primary` for the `#F05B43` orange).
* **Responsive Wrappers:** Any new screen-level widget must be wrapped in a responsive builder to guarantee functionality across mobile and desktop viewports.

## 3. Security and Admin Data
* **No Hardcoded Secrets:** Under no circumstances should API keys, admin passwords, or database URLs be hardcoded into the Dart files. Use `.env` files and the `flutter_dotenv` package.
* **Protected Routes:** The `/admin` and `/add-project` routes must implement authentication guards.

## 4. Code Quality
* **Null Safety:** Ensure absolute strict null safety. Use `?` and `!` operators judiciously and prefer default values over forced unwrapping.
* **Linter Compliance:** All code must pass the standard `flutter analyze` without warnings.