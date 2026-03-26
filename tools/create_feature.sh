#!/bin/bash

FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "❌ Feature name required"
  echo "Example: melos run create:feature auth"
  exit 1
fi

BASE_PATH="packages/features/$FEATURE"

echo "🚀 Creating feature: $FEATURE"

# 1. Create flutter package
flutter create --template=package $BASE_PATH

# 2. Create DDD structure
mkdir -p $BASE_PATH/lib/domain/entities
mkdir -p $BASE_PATH/lib/domain/repositories
mkdir -p $BASE_PATH/lib/domain/usecase

mkdir -p $BASE_PATH/lib/infrastructure/datasource
mkdir -p $BASE_PATH/lib/infrastructure/repositories

mkdir -p $BASE_PATH/lib/presentation/page
mkdir -p $BASE_PATH/lib/presentation/bloc

mkdir -p $BASE_PATH/lib/routing

# 3. Create starter files

cat > $BASE_PATH/lib/presentation/page/${FEATURE}_screen.dart <<EOL
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ${FEATURE^}Screen extends StatelessWidget {
  const ${FEATURE^}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE^}')),
      body: const Center(
        child: Text('${FEATURE^} Screen'),
      ),
    );
  }
}
EOL

cat > $BASE_PATH/lib/routing/${FEATURE}_route.dart <<EOL
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class ${FEATURE^}FeatureRoute extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [];

  @override
  List<AutoRouteGuard> get guards => [];
}
EOL

echo "✅ Feature $FEATURE created successfully!"