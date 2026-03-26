import 'package:auto_route/auto_route.dart';
import 'package:user/routing/user_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class UserFeatureRoute extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: UserRoute.page, initial: true)
  ];
  @override
  List<AutoRouteGuard> get guards => [];
}
