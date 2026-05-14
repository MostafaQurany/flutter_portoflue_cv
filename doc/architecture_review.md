# Architecture Review

## Current standard
- Keep the feature-first structure already present in `lib/`.
- Use `core/` for shared infrastructure such as routing, theming, responsive helpers, localization, and shared widgets.
- Use `features/<feature>/domain` for models and feature-level types.
- Use `features/<feature>/presentation` for pages, widgets, and providers.
- Treat `core/widgets` and `core/design_system` as the approved shared UI locations for this repo instead of creating a parallel `lib/widgets` tree.

## Dart file rules
- Prefer `const` constructors and `const` widget instances whenever possible.
- Use `RoutePaths` helpers instead of inline route strings.
- Keep widgets focused on presentation; move reusable state or guards into providers and routing.
- Keep asset paths centralized at the widget or helper level instead of scattering variants of the same path across files.
- Avoid fixed-width page containers outside shared responsive helpers. Use `LayoutBuilder`, `ResponsiveBuilder`, and constrained max widths instead.

## Frontend and web rules
- The portfolio design system is anchored to a dark background `#1E232B` and primary accent `#F05B43`.
- Shared gradients, borders, shadows, and muted text should derive from the theme layer rather than per-widget hardcoded colors.
- Asset filenames for web should use safe names only: lowercase or predictable ASCII names, no spaces, and no parentheses.
- Primary navigation, hero actions, project cards, and admin forms must remain usable at mobile, tablet, and desktop widths.

## Admin route constraints
- Client-side route guarding remains centralized in `GoRouter`.
- Admin credentials must not be hardcoded into source. Local development should provide them through:

```bash
flutter run -d chrome \
  --dart-define=PORTFOLIO_ADMIN_USERNAME=admin \
  --dart-define=PORTFOLIO_ADMIN_PASSWORD=change-me
```

- This remains frontend-only protection. Real security still requires a backend-authenticated admin flow before production use.
