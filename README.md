# Vantage

**Vantage** is a cross-platform **e-commerce** mobile app built with **Flutter**. It includes product browsing, a shopping cart, checkout, orders, user profile, wishlist, and Firebase-backed authentication. The project follows **Clean Architecture** and **DDD**, with **Cubit** (MVVM-style) for state and **auto_route** for navigation.

---

## Features (high level)

| Area | What you get |
|------|----------------|
| **Auth** | Sign in / sign up (email), Google sign-in, forgot password, session handling |
| **Shop** | Home, categories, search, product detail (sizes, colors, quantity), add to cart; main shell: **Home · Notifications · Orders · Profile** |
| **Cart & orders** | Cart, checkout with shipping address, place order, order confirmation, order history & detail |
| **Account** | Profile, edit profile, saved addresses (list + form) |
| **Other** | Wishlist (dedicated screens), notifications tab, help & support, light/dark theme |
| **UX** | English + Arabic (RTL-friendly patterns where applicable), loading shimmers, success animations |

---

## Tech stack

- **Flutter** (Dart SDK ^3.10)
- **Firebase**: Auth, Firestore, Storage
- **State**: `flutter_bloc` (Cubits)
- **DI**: `get_it`
- **Routing**: `auto_route`
- **i18n**: `easy_localization`
- **UI**: Material 3, `google_fonts`, `shimmer`, `cached_network_image`, etc.

---

## Project layout (short)

```
lib/
  core/           # Theme, shared widgets, catalog, translations base
  di/             # Dependency injection (GetIt)
  features/       # auth, home, cart, orders, profile, … (per feature: data / domain / presentation)
  router/         # app_router.dart (+ generated .gr.dart)
```

Details of patterns and rules are in [`CLAUDE.md`](CLAUDE.md).

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable, matching `pubspec.yaml`)
- For a **device/emulator build**: Android Studio / Xcode tooling as usual
- **Firebase**: a configured Firebase project with `google-services.json` / `GoogleService-Info.plist` (and any other platform config you use) — not committed here if you keep secrets private

---

## Getting started

```bash
flutter pub get
flutter run
```

---

## Code generation & maintenance

**Do not edit** generated files `*.g.dart` or `*.gr.dart` by hand. Change the **source** (router, JSON models, translations), then run the commands in [`terminal_commands.md`](terminal_commands.md).

---

## License

Add a `LICENSE` file in the repo if you want a public license (e.g. MIT). This template does not include one by default.

---

## Contributing

Use the workflow in `CLAUDE.md` (layers, Cubit rules, localization). Run `flutter analyze` before pushing.
