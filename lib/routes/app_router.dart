import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/viewmodels/auth_viewmodel.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/catalog/views/catalog_view.dart';
import '../features/checkout/views/checkout_view.dart';
import '../features/orders/views/orders_view.dart';
import '../features/orders/views/order_details_view.dart';
import '../features/admin/views/admin_users_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (!authState.isInitialized) return null;

      final isAuth = authState.isAuthenticated;
      final isLoggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/register';

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && isLoggingIn) {
        return authState.user?.isAdmin == true ? '/admin' : '/catalog';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const CatalogView(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutView(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersView(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return OrderDetailsView(orderId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminUsersView(),
      ),
    ],
  );
});
