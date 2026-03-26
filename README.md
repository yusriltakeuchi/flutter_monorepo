# Flutter Monorepo

Monorepo dengan **Melos** + **Dart pub workspace**. Semua versi dependency terpusat di root `pubspec.yaml`.

---

## 📁 Struktur

```
flutter_monorepo/
├── pubspec.yaml          ← semua versi dependency di sini
├── melos.yaml            ← konfigurasi Melos
├── Makefile
├── apps/
│   └── mobile_app/
└── packages/
    ├── core/             ← network, utils (pure Dart)
    ├── config/           ← konstanta & konfigurasi app
    ├── shared_ui/        ← widgets, theme, dan assets (icons, images)
    ├── shared_extension/ ← Dart/Flutter extensions
    └── features/
        ├── user/
        └── ...
```

---

## ⚙️ Setup

```bash
# Install Melos (sekali saja)
dart pub global activate melos

# Sync semua packages
flutter pub get
```

---

## 🚀 Jalankan App

```bash
make run-mobile

# atau
cd apps/mobile_app && flutter run -d <device_id>
```

---

## 🏗️ Build Runner

```bash
# Build semua packages
melos run build

# Build satu package saja
cd packages/features/user
dart run build_runner build --delete-conflicting-outputs
```

Kapan perlu dijalankan: setelah tambah `@RoutePage()`, `@freezed`, `@JsonSerializable`, atau asset baru.

---

## 🖼️ Assets

Asset disimpan di `packages/shared_ui/assets/` dan diakses melalui `shared_ui`.

### Tambah asset baru

```bash
# Tambah file ke folder yang sesuai
cp icon_baru.png packages/shared_ui/assets/icons/icon_baru.png

# Regenerate
melos run build
```

### Pakai di widget

`shared_ui` sudah di-import di setiap feature, jadi langsung pakai:

```dart
import 'package:shared_ui/shared_ui.dart';

Assets.icons.iconBaru.image(width: 24)
Assets.images.logoFull.image(fit: BoxFit.cover)

// Sebagai ImageProvider
DecorationImage(image: Assets.images.logoFull.provider())
```

> ⚠️ Setelah tambah file asset, **wajib** jalankan `melos run build` agar ter-generate.

---

## 📦 Buat Package Baru

**Dart package** (tanpa Flutter, contoh: `core`):
```bash
cd packages
dart create -t package-simple <nama> --force
```

**Flutter package** (contoh: `shared_ui`, `config`):
```bash
cd packages
flutter create --template=package <nama>
```

Setelah dibuat, edit `pubspec.yaml`-nya — tambahkan `resolution: workspace` dan hapus semua nomor versi (ikut root):

```yaml
name: <nama>
resolution: workspace       # ← wajib ada

environment:
  sdk: ^3.9.2

dependencies:
  dio:                      # ← tanpa versi
  flutter_bloc:

dev_dependencies:
  lints:
  build_runner:
```

Lalu daftarkan di root `pubspec.yaml` bagian `workspace`:
```yaml
workspace:
  - packages/<nama>    # ← tambahkan
  - apps/mobile_app
```

```bash
flutter pub get
```

---

## 🚀 Buat Feature Baru

### 1. Buat package

```bash
cd packages/features
flutter create --template=package <feature>
```

### 2. Buat struktur DDD

```bash
# Jalankan dari root monorepo
FEATURE=<nama_feature>

mkdir -p packages/features/$FEATURE/lib/{domain/{entities,repositories,usecase},infrastructure/{datasource,repositories},presentation/{page,bloc},routing}
touch packages/features/$FEATURE/lib/presentation/page/${FEATURE}_screen.dart
touch packages/features/$FEATURE/lib/routing/${FEATURE}_route.dart
```

```
features/<feature>/lib/
├── domain/
│   ├── entities/
│   ├── repositories/      ← abstract interface
│   └── usecase/
├── infrastructure/
│   ├── datasource/
│   └── repositories/      ← implementasi
├── presentation/
│   ├── bloc/
│   └── page/
└── routing/
```

### 3. Edit `pubspec.yaml` feature

```yaml
name: <feature>
resolution: workspace

environment:
  sdk: ^3.9.2
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  auto_route:
  shared_ui:
    path: ../../shared_ui
  config:
    path: ../../config
  shared_extension:
    path: ../../shared_extension

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints:
  auto_route_generator:
  build_runner:
```

### 4. Daftarkan ke workspace & mobile_app

Root `pubspec.yaml`:
```yaml
workspace:
  - packages/features/<feature>   # ← tambahkan
```

`apps/mobile_app/pubspec.yaml`:
```yaml
dependencies:
  <feature>:
    path: ../../packages/features/<feature>
```

```bash
flutter pub get
```

---

## 🗺️ Setup Router Feature

### 1. Screen — pakai `@RoutePage()`

```dart
// lib/presentation/page/<feature>_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold();
}
```

### 2. Router config feature

Setiap feature punya router sendiri yang **menyimpan semua routes-nya**.

```dart
// lib/routing/<feature>_route.dart
import 'package:auto_route/auto_route.dart';
import 'package:product/routing/product_route.gr.dart';   // ← import .gr.dart milik sendiri

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class ProductFeatureRoute extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ProductRoute.page, initial: true),   // ← define routes di sini
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
```

### 3. Generate

```bash
melos run build
# → <feature>_route.gr.dart ter-generate
```

### 4. Daftarkan di AppRouter (mobile_app)

AppRouter cukup **spread** routes dari tiap feature — tidak perlu import `.gr.dart` secara langsung.

```dart
// apps/mobile_app/lib/routing/route.dart
import 'package:auto_route/auto_route.dart';
import 'package:user/routing/user_route.dart';
import 'package:product/routing/product_route.dart';   // ← import router class feature

part 'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    ...UserFeatureRoute().routes,
    ...ProductFeatureRoute().routes,   // ← spread routes feature baru
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
```

```bash
melos run build   # update route.gr.dart mobile_app
make run-mobile
```

---

## 💉 Aturan Dependencies

- **Versi hanya boleh ada di root `pubspec.yaml`**
- Package individual cukup tulis nama tanpa versi

```yaml
# ✅ Benar (di package individual)
dependencies:
  auto_route:
  flutter_bloc:

# ❌ Salah
dependencies:
  auto_route: ^11.1.0
```

---

## 📋 Commands

| Command | Fungsi |
|---|---|
| `melos bootstrap` | Sync semua packages |
| `flutter pub get` | Sync semua dependencies |
| `make run-mobile` | Run mobile app |
| `melos run build` | Code generation (build_runner) |
| `melos run format:select` | Format semua Flutter packages |

