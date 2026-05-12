import 'package:get/get.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/products/views/product_list_screen.dart';
import '../../features/products/views/add_product_screen.dart';
import '../../features/cart/views/cart_screen.dart';
import '../../features/orders/views/order_list_screen.dart';
import '../../features/orders/views/order_detail_screen.dart';
import '../../features/staff/views/staff_management_screen.dart';
import '../../features/auth/views/profile_screen.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.products,
      page: () => const ProductListScreen(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductScreen(),
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: Routes.orderList,
      page: () => const OrderListScreen(),
    ),
    GetPage(
      name: Routes.orderDetail,
      page: () => const OrderDetailScreen(),
    ),
    GetPage(
      name: Routes.staffManagement,
      page: () => const StaffManagementScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
    ),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const register = '/register';
  static const products = '/products';
  static const addProduct = '/add-product';
  static const cart = '/cart';
  static const orderList = '/orders';
  static const orderDetail = '/order-detail';
  static const staffManagement = '/staff-management';
  static const profile = '/profile';
}
