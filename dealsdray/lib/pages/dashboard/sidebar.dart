import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../../utils/theme_provider.dart';
import '../user/user_view_model.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Debugging: Print the current theme state
        print('Sidebar rebuilding with theme: ${themeProvider.isDarkTheme ? "Dark" : "Light"}');
        print('Primary color: ${Theme.of(context).colorScheme.primary}');
        print('Secondary color: ${Theme.of(context).colorScheme.secondary}');
        print('OnSurface color: ${Theme.of(context).colorScheme.onSurface}');

        return Drawer(
          width: MediaQuery.of(context).size.width * 0.75,
          backgroundColor: Theme.of(context).colorScheme.surface, // Ensure Drawer uses theme background
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/splash_screen.png'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userViewModel.user?.name ?? 'John Doe',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userViewModel.user?.email ?? 'johndoe@example.com',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.brightness_6,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Dark Theme',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Theme switched to ${themeProvider.isDarkTheme ? "Dark" : "Light"}'),
                      ),
                    );
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveThumbColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.home,
                title: 'Home',
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.shopping_cart,
                title: 'My Orders',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to My Orders page
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.favorite,
                title: 'Wishlist',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Wishlist page
                },
              ),
              const Divider(
                color: Colors.grey, // Ensure divider color is visible in both themes
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  await userViewModel.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      onTap: onTap,
    );
  }
}