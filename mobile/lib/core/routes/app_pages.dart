import 'package:get/get.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/products/views/product_list_screen.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.products,
      page: () => const ProductListScreen(),
    ),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const products = '/products';
}
