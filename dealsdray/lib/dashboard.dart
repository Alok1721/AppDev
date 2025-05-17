import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> dashboardData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'),
      );

      if (response.statusCode == 200) {
        setState(() {
          dashboardData = jsonDecode(response.body)['data'] ?? {};
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Failed to fetch dashboard data: ${response.body}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner One (Carousel)
              _buildBannerSection(dashboardData['banner_one'], 200),
              const SizedBox(height: 10),

              // Categories
              _buildSectionTitle('Categories'),
              _buildCategorySection(dashboardData['category']),
              const SizedBox(height: 10),

              // Products
              _buildSectionTitle('Featured Products'),
              _buildHorizontalProductList(dashboardData['products']),
              const SizedBox(height: 10),

              // Banner Two
              _buildBannerSection(dashboardData['banner_two'], 100),
              const SizedBox(height: 10),

              // New Arrivals
              _buildSectionTitle('New Arrivals'),
              _buildHorizontalProductList(dashboardData['new_arrivals']),
              const SizedBox(height: 10),

              // Banner Three (Carousel)
              _buildBannerSection(dashboardData['banner_three'], 150),
              const SizedBox(height: 10),

              // Categories Listing
              _buildSectionTitle('Explore Categories'),
              _buildHorizontalProductList(dashboardData['categories_listing']),
              const SizedBox(height: 10),

              // Top Brands
              _buildSectionTitle('Top Brands'),
              _buildBannerSection(dashboardData['top_brands'], 100),
              const SizedBox(height: 10),

              // Brand Listing
              _buildSectionTitle('Brand Deals'),
              _buildHorizontalProductList(dashboardData['brand_listing']),
              const SizedBox(height: 10),

              // Top Selling Products
              _buildSectionTitle('Top Selling Products'),
              _buildHorizontalProductList(dashboardData['top_selling_products'], showOffer: false),
              const SizedBox(height: 10),

              // Featured Laptops
              _buildSectionTitle('Featured Laptops'),
              _buildFeaturedLaptops(dashboardData['featured_laptops']),
              const SizedBox(height: 10),

              // Upcoming Laptops
              _buildSectionTitle('Upcoming Laptops'),
              _buildBannerSection(dashboardData['upcoming_laptops'], 100),
              const SizedBox(height: 10),

              // Unboxed Deals
              _buildSectionTitle('Unboxed Deals'),
              _buildHorizontalProductList(dashboardData['unboxed_deals']),
              const SizedBox(height: 10),

              // My Browsing History
              _buildSectionTitle('Browsing History'),
              _buildHorizontalProductList(dashboardData['my_browsing_history']),
              const SizedBox(height: 80), // Extra space for FAB
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

  Widget _buildBannerSection(List<dynamic>? banners, double height) {
    if (banners == null || banners.isEmpty) {
      return const SizedBox.shrink();
    }
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
              image: NetworkImage(banner['banner'] ?? banner['icon'] ?? 'https://via.placeholder.com/300'),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(List<dynamic>? categories) {
    if (categories == null || categories.isEmpty) {
      return const SizedBox.shrink();
    }
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
                  backgroundImage: NetworkImage(category['icon'] ?? 'https://via.placeholder.com/50'),
                ),
                const SizedBox(height: 5),
                Text(category['label'] ?? 'Category'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalProductList(List<dynamic>? items, {bool showOffer = true}) {
    if (items == null || items.isEmpty) {
      return const SizedBox.shrink();
    }
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
                        item['icon'] ?? 'https://via.placeholder.com/150',
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
                        if (item['brandIcon'] != null)
                          Image.network(
                            item['brandIcon'],
                            height: 20,
                            width: 20,
                          ),
                        const SizedBox(height: 5),
                        Text(
                          item['label'] ?? 'Product',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item['Sublabel'] != null || item['SubLabel'] != null)
                          Text(
                            item['Sublabel'] ?? item['SubLabel'] ?? '',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (showOffer && item['offer'] != null)
                          Text(
                            '${item['offer']}% off',
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

  Widget _buildFeaturedLaptops(List<dynamic>? laptops) {
    if (laptops == null || laptops.isEmpty) {
      return const SizedBox.shrink();
    }
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
                    laptop['icon'] ?? 'https://via.placeholder.com/100',
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
                          laptop['brandIcon'] ?? 'https://via.placeholder.com/20',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          laptop['label'] ?? 'Laptop',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${laptop['price'] ?? 'N/A'}',
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