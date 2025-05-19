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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.isLoading && viewModel.dashboardData == null && viewModel.errorMessage == null) {
          viewModel.fetchDashboardData();
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: const Sidebar(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
                size: screenWidth * 0.06,
              ),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: Container(
              width: screenWidth * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    size: screenWidth * 0.05,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Badge(
                  smallSize: screenWidth * 0.02,
                  child: Icon(
                    Icons.notifications_outlined,
                    size: screenWidth * 0.06,
                  ),
                ),
                onPressed: () {},
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                  if (viewModel.cartItems.isNotEmpty)
                    Positioned(
                      right: screenWidth * 0.01,
                      top: screenWidth * 0.01,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.005),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                        ),
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.04,
                          minHeight: screenWidth * 0.04,
                        ),
                        child: Text(
                          '${viewModel.cartItems.length}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: screenWidth * 0.025,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: screenWidth * 0.025),
            ],
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.015),
                ElevatedButton(
                  onPressed: viewModel.fetchDashboardData,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: viewModel.fetchDashboardData,
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              child: DashboardContent(viewModel: viewModel),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 4,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              // TODO: Implement chat functionality
            },
            child: Icon(
              Icons.chat,
              size: screenWidth * 0.06,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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