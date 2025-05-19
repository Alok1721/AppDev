import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/products.dart';
import 'dashboard_repo.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepo dashboardRepo;
  DashboardResponse? dashboardData;
  bool isLoading = false;
  String? errorMessage;

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  DashboardViewModel({required this.dashboardRepo}) {
    fetchDashboardData();
    _loadCart();
  }

  Future<void> fetchDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboardData = await dashboardRepo.fetchDashboardData();
      debugPrint('Dashboard data fetched: ${dashboardData}');
    } catch (e) {
      errorMessage = 'Failed to load dashboard data: $e';
      debugPrint('Dashboard fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(dynamic item, {required double price}) {
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.item == item);
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(item: item, quantity: 1, price: price));
    }
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(dynamic item) {
    _cartItems.removeWhere((cartItem) => cartItem.item == item);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(dynamic item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
    } else {
      final index = _cartItems.indexWhere((cartItem) => cartItem.item == item);
      if (index != -1) {
        _cartItems[index].quantity = newQuantity;
        _saveCart();
        notifyListeners();
      }
    }
  }

  double get subtotal {
    double total = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.item is FeaturedLaptop) {
        total += double.parse((cartItem.item as FeaturedLaptop).price) * cartItem.quantity;
      } else if (cartItem.price != null) {
        total += cartItem.price! * cartItem.quantity;
      }
    }
    return total;
  }

  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = _cartItems.map((cartItem) {
      final item = cartItem.item;
      if (item is Product) {
        return 'Product|${item.label}|${item.icon}|${cartItem.price}|${cartItem.quantity}';
      } else if (item is FeaturedLaptop) {
        return 'FeaturedLaptop|${item.label}|${item.icon}|${item.price}|${cartItem.quantity}';
      }
      return '';
    }).toList();
    await prefs.setStringList('cartItems', cartData);
    debugPrint('Cart saved: $cartData');
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cartItems') ?? [];
    _cartItems = cartData.map((data) {
      final parts = data.split('|');
      final type = parts[0];
      final label = parts[1];
      final icon = parts[2];
      final price = double.parse(parts[3]);
      final quantity = int.parse(parts[4]);

      if (type == 'Product') {
        return CartItem(
          item: Product(
            icon: icon,
            label: label,
            offer: null,
          ),
          quantity: quantity,
          price: price,
        );
      } else if (type == 'FeaturedLaptop') {
        return CartItem(
          item: FeaturedLaptop(
            icon: icon,
            label: label,
            price: price.toString(),
            brandIcon: '',
          ),
          quantity: quantity,
        );
      }
      return null;
    }).where((item) => item != null).cast<CartItem>().toList();
    notifyListeners();
    debugPrint('Cart loaded: $_cartItems');
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
    notifyListeners();
  }
}

class CartItem {
  final dynamic item;
  int quantity;
  final double? price;

  CartItem({required this.item, required this.quantity, this.price});
}