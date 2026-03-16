import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/creditos/presentation/screens/credit_info_screen.dart';
import '../../features/creditos/presentation/screens/simulator_screen.dart';
import '../../features/creditos/presentation/screens/my_credits_screen.dart';
import '../../features/creditos/presentation/screens/credit_detail_screen.dart';
import '../../features/creditos/domain/models/credit_models.dart';
import '../../features/perfil/presentation/screens/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final authState = ref.read(authProvider).state;
      
      if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
        return null;
      }

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoginPage = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginPage) return '/login';
      if (isAuthenticated && isLoginPage) return '/home';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/creditos/info',
        builder: (context, state) => const CreditInfoScreen(),
      ),
      GoRoute(
        path: '/creditos/simulador',
        builder: (context, state) => const SimulatorScreen(),
      ),
      GoRoute(
        path: '/creditos/mis-creditos',
        builder: (context, state) => const MyCreditsScreen(),
      ),
      GoRoute(
        path: '/creditos/detalle/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CreditDetailScreen(requestId: id);
        },
      ),
      GoRoute(
        path: '/creditos/editar/:id',
        builder: (context, state) {
          final credit = state.extra as CreditRequest?;
          return CreditInfoScreen(creditRequest: credit);
        },
      ),
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  // Trigger router refresh whenever auth state changes
  ref.listen(authProvider, (previous, next) {
    router.refresh();
  });

  return router;
});
