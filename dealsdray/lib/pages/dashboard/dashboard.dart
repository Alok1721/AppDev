import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_widgets.dart';
import '../user/profile_page.dart';
import 'dashboard_content.dart';
import 'dashboard_view_model.dart';
import 'sidebar.dart';
import 'cart_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.isLoading && viewModel.dashboardData == null && viewModel.errorMessage == null) {
          viewModel.fetchDashboardData();
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: const Sidebar(),
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search here',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Badge(
                  smallSize: 8,
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () {},
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                  if (viewModel.cartItems.isNotEmpty)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${viewModel.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
            ],
            backgroundColor: Colors.white,
            elevation: 0.5,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: viewModel.fetchDashboardData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: viewModel.fetchDashboardData,
            color: Colors.red,
            child: SingleChildScrollView(
              child: DashboardContent(viewModel: viewModel),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: () {
              // TODO: Implement chat functionality
            },
            child: const Icon(Icons.chat, color: Colors.white),
          ),
          bottomNavigationBar: CommonBottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              }
              // TODO: Handle other navigation (e.g., Categories, Deals)
            },
          ),
        );
      },
    );
  }
}