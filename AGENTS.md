# Portfolio Project Agents

## Project Scope
This project is a responsive personal developer portfolio built with Flutter. It includes a public-facing UI and a secure, authenticated admin route for adding and managing projects dynamically.

## Architecture Boundaries
* **Framework:** Flutter (Web and Mobile targeting).
* **State Management:** Riverpod (or specify your preferred).
* **Routing:** GoRouter (must handle secure routing for the /admin pages).
* **Design System:** Strict adherence to the dark theme (`#1E232B` background, `#F05B43` primary orange accent).

## Rules & Constraints
* **Responsive First:** All UI components must adapt between mobile and desktop views using `LayoutBuilder` or standard responsive practices. No hardcoded fixed widths for main layout containers.
* **Componentization:** Break complex views into small, reusable widgets in a `lib/widgets/` directory.
* **Security:** Admin routes must be guarded. No sensitive keys or credentials should be present in the frontend code.
* **Clean Code:** Use `const` constructors wherever possible. Keep build methods clean.