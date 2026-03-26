import 'package:auto_route/auto_route.dart';
import 'package:user/routing/user_route.dart';

part 'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    ...UserFeatureRoute().routes
  ];
  @override
  List<AutoRouteGuard> get guards => [];
}
