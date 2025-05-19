import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../models/products.dart';
import 'dashboard_view_model.dart';

class DashboardContent extends StatelessWidget {
  final DashboardViewModel viewModel;

  const DashboardContent({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerSection(banners: viewModel.dashboardData!.bannerOne, height: 200),
        const SizedBox(height: 20),
        SectionTitle(title: 'Categories'),
        CategorySection(categories: viewModel.dashboardData!.categories),
        const SizedBox(height: 20),
        SectionTitle(title: 'Featured Products'),
        ProductListSection(
          items: viewModel.dashboardData!.products,
          onAddToCart: (item) => _addToCart(context, item, 10000), // Example price
        ),
        const SizedBox(height: 20),
        BannerSection(banners: viewModel.dashboardData!.bannerTwo, height: 100),
        const SizedBox(height: 20),
        SectionTitle(title: 'New Arrivals'),
        ProductListSection(
          items: viewModel.dashboardData!.newArrivals,
          onAddToCart: (item) => _addToCart(context, item, 12000),
        ),
        const SizedBox(height: 20),
        BannerSection(banners: viewModel.dashboardData!.bannerThree, height: 150),
        const SizedBox(height: 20),
        SectionTitle(title: 'Explore Categories'),
        ProductListSection(
          items: viewModel.dashboardData!.categoriesListing,
          onAddToCart: (item) => _addToCart(context, item, 8000),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: 'Top Brands'),
        BannerSection(banners: viewModel.dashboardData!.topBrands, height: 100),
        const SizedBox(height: 20),
        SectionTitle(title: 'Brand Deals'),
        ProductListSection(
          items: viewModel.dashboardData!.brandListing,
          onAddToCart: (item) => _addToCart(context, item, 15000),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: 'Top Selling Products'),
        ProductListSection(
          items: viewModel.dashboardData!.topSellingProducts,
          showOffer: false,
          onAddToCart: (item) => _addToCart(context, item, 9000),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: 'Featured Laptops'),
        FeaturedLaptopSection(
          laptops: viewModel.dashboardData!.featuredLaptops,
          onAddToCart: (item) => _addToCart(context, item, double.parse(item.price)),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: 'Upcoming Laptops'),
        BannerSection(banners: viewModel.dashboardData!.upcomingLaptops, height: 100),
        const SizedBox(height: 20),
        SectionTitle(title: 'Unboxed Deals'),
        ProductListSection(
          items: viewModel.dashboardData!.unboxedDeals,
          onAddToCart: (item) => _addToCart(context, item, 5000),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: 'Browsing History'),
        ProductListSection(
          items: viewModel.dashboardData!.myBrowsingHistory,
          onAddToCart: (item) => _addToCart(context, item, 11000),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  void _addToCart(BuildContext context, dynamic item, double price) {
    Provider.of<DashboardViewModel>(context, listen: false).addToCart(item, price: price);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.label} added to cart')),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class BannerSection extends StatelessWidget {
  final List<Banners> banners;
  final double height;

  const BannerSection({super.key, required this.banners, required this.height});

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
        ),
        items: banners.map((banner) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(
                    banner.banner.isNotEmpty ? banner.banner : 'https://via.placeholder.com/300'),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) => const AssetImage('assets/placeholder.png'),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<Category> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: NetworkImage(
                        category.icon.isNotEmpty ? category.icon : 'https://via.placeholder.com/50'),
                    onBackgroundImageError: (exception, stackTrace) =>
                    const AssetImage('assets/placeholder.png'),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductListSection extends StatelessWidget {
  final List<Product> items;
  final bool showOffer;
  final Function(dynamic) onAddToCart;

  const ProductListSection({
    super.key,
    required this.items,
    this.showOffer = true,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            item.icon.isNotEmpty ? item.icon : 'https://via.placeholder.com/150',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png'),
                          ),
                        ),
                        if (showOffer && item.offer != null)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                '${item.offer}% OFF',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
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
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          const SizedBox(height: 5),
                          Text(
                            item.label,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                          const SizedBox(height: 5),
                          Text(
                            '₹N/A',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => onAddToCart(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeaturedLaptopSection extends StatelessWidget {
  final List<FeaturedLaptop> laptops;
  final Function(dynamic) onAddToCart;

  const FeaturedLaptopSection({
    super.key,
    required this.laptops,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (laptops.isEmpty) return const SizedBox.shrink();
    return Column(
      children: laptops.map((laptop) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                    child: Image.network(
                      laptop.icon.isNotEmpty ? laptop.icon : 'https://via.placeholder.com/100',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/placeholder.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            laptop.brandIcon.isNotEmpty
                                ? laptop.brandIcon
                                : 'https://via.placeholder.com/20',
                            height: 20,
                            width: 20,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            laptop.label,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '₹${laptop.price}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                ' 4.5',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => onAddToCart(laptop),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}