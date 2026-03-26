#!/bin/bash

FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "❌ Feature name required"
  echo "Usage: melos run create:feature <feature_name>"
  exit 1
fi

# Convert to Capitalized (auth -> Auth)
FEATURE_CAP=$(echo "$FEATURE" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

BASE_PATH="packages/features/$FEATURE"

echo "🚀 Creating feature: $FEATURE"

# 1. Create flutter package
flutter create --template=package $BASE_PATH

# 2. Remove default files (biar clean)
rm -rf $BASE_PATH/lib/${FEATURE}.dart

# 3. Create DDD structure
mkdir -p $BASE_PATH/lib/domain/entities
mkdir -p $BASE_PATH/lib/domain/repositories
mkdir -p $BASE_PATH/lib/domain/usecase

mkdir -p $BASE_PATH/lib/infrastructure/datasource
mkdir -p $BASE_PATH/lib/infrastructure/repositories

mkdir -p $BASE_PATH/lib/presentation/page
mkdir -p $BASE_PATH/lib/presentation/bloc

mkdir -p $BASE_PATH/lib/routing

# 4. Create Screen
cat > $BASE_PATH/lib/presentation/page/${FEATURE}_screen.dart <<EOL
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ${FEATURE_CAP}Screen extends StatelessWidget {
  const ${FEATURE_CAP}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE_CAP}')),
      body: const Center(
        child: Text('${FEATURE_CAP} Screen'),
      ),
    );
  }
}
EOL

# 5. Create Route
cat > $BASE_PATH/lib/routing/${FEATURE}_route.dart <<EOL
import 'package:auto_route/auto_route.dart';
import '../presentation/page/${FEATURE}_screen.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class ${FEATURE_CAP}FeatureRoute extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ${FEATURE_CAP}Route.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
EOL

# 6. Update pubspec.yaml (inject core dependency)
cat >> $BASE_PATH/pubspec.yaml <<EOL

dependencies:
  core:
    path: ../../core
EOL

echo "📦 Running melos bootstrap..."
melos bootstrap

echo "✅ Feature $FEATURE created successfully!"