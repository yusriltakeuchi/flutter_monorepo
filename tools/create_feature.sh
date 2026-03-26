#!/bin/bash

FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "❌ Feature name required"
  echo "Usage: melos run create:feature -- <feature_name>"
  exit 1
fi

# Convert snake_case -> PascalCase (product_order -> ProductOrder), macOS-safe
FEATURE_CLASS=$(echo "$FEATURE" | awk -F'_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); OFS=""; print}')

BASE_PATH="packages/features/$FEATURE"

echo "🚀 Creating feature: $FEATURE ($FEATURE_CLASS)"

# 1. Create flutter package
flutter create --template=package "$BASE_PATH"

# 2. Remove default generated lib file
rm -f "$BASE_PATH/lib/${FEATURE}.dart"

# 3. Create DDD structure
mkdir -p "$BASE_PATH/lib/domain/entities"
mkdir -p "$BASE_PATH/lib/domain/repositories"
mkdir -p "$BASE_PATH/lib/domain/usecase"

mkdir -p "$BASE_PATH/lib/infrastructure/datasource"
mkdir -p "$BASE_PATH/lib/infrastructure/repositories"

mkdir -p "$BASE_PATH/lib/presentation/page"
mkdir -p "$BASE_PATH/lib/presentation/bloc"

mkdir -p "$BASE_PATH/lib/routing"

# 4. Overwrite pubspec.yaml with full workspace template
cat > "$BASE_PATH/pubspec.yaml" << EOF
name: $FEATURE
description: "Feature $FEATURE."
version: 0.0.1
resolution: workspace
publish_to: none

environment:
  sdk: ^3.9.2
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  auto_route:
  freezed_annotation:
  dartz:
  flutter_bloc:
  core:
    path: ../../core
  shared_ui:
    path: ../../shared_ui
  config:
    path: ../../config
  shared_extension:
    path: ../../shared_extension
  theme:
    path: ../theme

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints:
  auto_route_generator:
  build_runner:
  freezed:
  json_serializable:

flutter:
EOF

# 5. Create Screen template
cat > "$BASE_PATH/lib/presentation/page/${FEATURE}_screen.dart" << EOF
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ${FEATURE_CLASS}Screen extends StatelessWidget {
  const ${FEATURE_CLASS}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${FEATURE_CLASS} Screen'),
      ),
    );
  }
}
EOF

# 6. Create Router template
cat > "$BASE_PATH/lib/routing/${FEATURE}_route.dart" << EOF
import 'package:auto_route/auto_route.dart';
import 'package:$FEATURE/routing/${FEATURE}_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class ${FEATURE_CLASS}FeatureRoute extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ${FEATURE_CLASS}Route.page, initial: true),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
EOF

echo ""
echo "✅ Feature '$FEATURE' created!"
echo ""
echo "📝 Next steps:"
echo "   1. Tambahkan ke root pubspec.yaml (workspace):"
echo "        - $BASE_PATH"
echo ""
echo "   2. Tambahkan ke apps/mobile_app/pubspec.yaml (dependencies):"
echo "        $FEATURE:"
echo "          path: ../../$BASE_PATH"
echo ""
echo "   3. flutter pub get"
echo "   4. melos run build"
echo "   5. Register route di apps/mobile_app/lib/routing/route.dart:"
echo "        import 'package:$FEATURE/routing/${FEATURE}_route.dart';"
echo "        ...${FEATURE_CLASS}FeatureRoute().routes,"
