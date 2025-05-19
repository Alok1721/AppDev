import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products.dart';
import 'dashboard_view_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Cart',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: Theme.of(context).appBarTheme.elevation,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: viewModel.cartItems.isEmpty
              ? Center(
            child: Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = viewModel.cartItems[index];
                    final item = cartItem.item;
                    String label = '';
                    String imageUrl = '';
                    double price = 0;

                    if (item is Product) {
                      label = item.label;
                      imageUrl = item.icon;
                      price = cartItem.price!;
                    } else if (item is FeaturedLaptop) {
                      label = item.label;
                      imageUrl = item.icon;
                      price = double.parse(item.price);
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).cardTheme.color,
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/80',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/placeholder.png'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '₹${price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                        onPressed: () {
                                          viewModel.updateQuantity(item, cartItem.quantity - 1);
                                        },
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          viewModel.updateQuantity(item, cartItem.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {
                                viewModel.removeFromCart(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$label removed from cart')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '₹${viewModel.subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax (10%)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '₹${viewModel.tax.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '₹${viewModel.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Proceeding to checkout...')),
                          );
                        },
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}