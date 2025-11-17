import 'package:go_router/go_router.dart';

import '../../core/constants/route_constants.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: appRoutes,
  errorBuilder: (context, state) => buildRouteErrorPage(context, state),
  debugLogDiagnostics: false,
);
