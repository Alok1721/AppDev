import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/products.dart';
import 'dashboard_view_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);

    if (!viewModel.isLoading && viewModel.dashboardData == null) {
      viewModel.fetchDashboardData();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search here',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(viewModel.errorMessage!),
            ElevatedButton(
              onPressed: () => viewModel.fetchDashboardData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: viewModel.fetchDashboardData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerSection(viewModel.dashboardData!.bannerOne, 200),
              const SizedBox(height: 10),
              _buildSectionTitle('Categories'),
              _buildCategorySection(viewModel.dashboardData!.categories),
              const SizedBox(height: 10),
              _buildSectionTitle('Featured Products'),
              _buildHorizontalProductList(viewModel.dashboardData!.products),
              const SizedBox(height: 10),
              _buildBannerSection(viewModel.dashboardData!.bannerTwo, 100),
              const SizedBox(height: 10),
              _buildSectionTitle('New Arrivals'),
              _buildHorizontalProductList(viewModel.dashboardData!.newArrivals),
              const SizedBox(height: 10),
              _buildBannerSection(viewModel.dashboardData!.bannerThree, 150),
              const SizedBox(height: 10),
              _buildSectionTitle('Explore Categories'),
              _buildHorizontalProductList(viewModel.dashboardData!.categoriesListing),
              const SizedBox(height: 10),
              _buildSectionTitle('Top Brands'),
              _buildBannerSection(viewModel.dashboardData!.topBrands, 100),
              const SizedBox(height: 10),
              _buildSectionTitle('Brand Deals'),
              _buildHorizontalProductList(viewModel.dashboardData!.brandListing),
              const SizedBox(height: 10),
              _buildSectionTitle('Top Selling Products'),
              _buildHorizontalProductList(viewModel.dashboardData!.topSellingProducts, showOffer: false),
              const SizedBox(height: 10),
              _buildSectionTitle('Featured Laptops'),
              _buildFeaturedLaptops(viewModel.dashboardData!.featuredLaptops),
              const SizedBox(height: 10),
              _buildSectionTitle('Upcoming Laptops'),
              _buildBannerSection(viewModel.dashboardData!.upcomingLaptops, 100),
              const SizedBox(height: 10),
              _buildSectionTitle('Unboxed Deals'),
              _buildHorizontalProductList(viewModel.dashboardData!.unboxedDeals),
              const SizedBox(height: 10),
              _buildSectionTitle('Browsing History'),
              _buildHorizontalProductList(viewModel.dashboardData!.myBrowsingHistory),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildBannerSection(List<Banners> banners, double height) {
    if (banners.isEmpty) return const SizedBox.shrink();
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: banners.map((banner) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(banner.banner.isNotEmpty ? banner.banner : 'https://via.placeholder.com/300'),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(List<Category> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(category.icon.isNotEmpty ? category.icon : 'https://via.placeholder.com/50'),
                ),
                const SizedBox(height: 5),
                Text(category.label),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalProductList(List<Product> items, {bool showOffer = true}) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        item.icon.isNotEmpty ? item.icon : 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.brandIcon != null && item.brandIcon!.isNotEmpty)
                          Image.network(
                            item.brandIcon!,
                            height: 20,
                            width: 20,
                          ),
                        const SizedBox(height: 5),
                        Text(
                          item.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.subLabel != null && item.subLabel!.isNotEmpty)
                          Text(
                            item.subLabel!,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (showOffer && item.offer != null)
                          Text(
                            '${item.offer}% off',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedLaptops(List<FeaturedLaptop> laptops) {
    if (laptops.isEmpty) return const SizedBox.shrink();
    return Column(
      children: laptops.map((laptop) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                  child: Image.network(
                    laptop.icon.isNotEmpty ? laptop.icon : 'https://via.placeholder.com/100',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          laptop.brandIcon.isNotEmpty ? laptop.brandIcon : 'https://via.placeholder.com/20',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          laptop.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${laptop.price}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}