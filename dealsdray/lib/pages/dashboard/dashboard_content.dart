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
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerSection(banners: viewModel.dashboardData!.bannerOne, height: screenHeight * 0.2),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Categories'),
        CategorySection(categories: viewModel.dashboardData!.categories),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Featured Products'),
        ProductListSection(
          items: viewModel.dashboardData!.products,
          onAddToCart: (item) => _addToCart(context, item, 10000),
        ),
        SizedBox(height: screenHeight * 0.02),
        BannerSection(banners: viewModel.dashboardData!.bannerTwo, height: screenHeight * 0.15),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'New Arrivals'),
        ProductListSection(
          items: viewModel.dashboardData!.newArrivals,
          onAddToCart: (item) => _addToCart(context, item, 12000),
        ),
        SizedBox(height: screenHeight * 0.02),
        BannerSection(banners: viewModel.dashboardData!.bannerThree, height: screenHeight * 0.2),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Explore Categories'),
        ProductListSection(
          items: viewModel.dashboardData!.categoriesListing,
          onAddToCart: (item) => _addToCart(context, item, 8000),
        ),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Top Brands'),
        BannerSection(banners: viewModel.dashboardData!.topBrands, height: screenHeight * 0.15),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Brand Deals'),
        ProductListSection(
          items: viewModel.dashboardData!.brandListing,
          onAddToCart: (item) => _addToCart(context, item, 15000),
        ),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Top Selling Products'),
        ProductListSection(
          items: viewModel.dashboardData!.topSellingProducts,
          showOffer: false,
          onAddToCart: (item) => _addToCart(context, item, 9000),
        ),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Featured Laptops'),
        FeaturedLaptopSection(
          laptops: viewModel.dashboardData!.featuredLaptops,
          onAddToCart: (item) => _addToCart(context, item, double.parse(item.price)),
        ),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Upcoming Laptops'),
        BannerSection(banners: viewModel.dashboardData!.upcomingLaptops, height: screenHeight * 0.15),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Unboxed Deals'),
        ProductListSection(
          items: viewModel.dashboardData!.unboxedDeals,
          onAddToCart: (item) => _addToCart(context, item, 5000),
        ),
        SizedBox(height: screenHeight * 0.02),
        const SectionTitle(title: 'Browsing History'),
        ProductListSection(
          items: viewModel.dashboardData!.myBrowsingHistory,
          onAddToCart: (item) => _addToCart(context, item, 11000),
        ),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }

  void _addToCart(BuildContext context, dynamic item, double price) {
    Provider.of<DashboardViewModel>(context, listen: false).addToCart(item, price: price);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.label} added to cart',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.012),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See All',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: screenWidth * 0.035,
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;

    if (banners.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.012),
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
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
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
    final screenWidth = MediaQuery.of(context).size.width;

    if (categories.isEmpty) return const SizedBox.shrink();
    return Container(
      height: screenWidth * 0.25,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.012),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: screenWidth * 0.2,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    backgroundImage: NetworkImage(
                        category.icon.isNotEmpty ? category.icon : 'https://via.placeholder.com/50'),
                    onBackgroundImageError: (exception, stackTrace) =>
                    const AssetImage('assets/placeholder.png'),
                  ),
                  SizedBox(height: screenWidth * 0.012),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Theme.of(context).colorScheme.onSurface,
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
    final screenWidth = MediaQuery.of(context).size.width;

    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: screenWidth * 0.65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: screenWidth * 0.4,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.03)),
                          child: Image.network(
                            item.icon.isNotEmpty ? item.icon : 'https://via.placeholder.com/150',
                            height: screenWidth * 0.25,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png'),
                          ),
                        ),
                        if (showOffer && item.offer != null)
                          Positioned(
                            top: screenWidth * 0.02,
                            left: screenWidth * 0.02,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.015,
                                vertical: screenWidth * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                              ),
                              child: Text(
                                '${item.offer}% OFF',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.brandIcon != null && item.brandIcon!.isNotEmpty)
                            Image.network(
                              item.brandIcon!,
                              height: screenWidth * 0.05,
                              width: screenWidth * 0.05,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          SizedBox(height: screenWidth * 0.012),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.subLabel != null && item.subLabel!.isNotEmpty)
                            Text(
                              item.subLabel!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: screenWidth * 0.03,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(height: screenWidth * 0.012),
                          Text(
                            '₹N/A',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.012),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => onAddToCart(item),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                ),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: screenWidth * 0.03),
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
    final screenWidth = MediaQuery.of(context).size.width;

    if (laptops.isEmpty) return const SizedBox.shrink();
    return Column(
      children: laptops.map((laptop) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.012),
            child: Card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(screenWidth * 0.03)),
                    child: Image.network(
                      laptop.icon.isNotEmpty ? laptop.icon : 'https://via.placeholder.com/100',
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/placeholder.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            laptop.brandIcon.isNotEmpty
                                ? laptop.brandIcon
                                : 'https://via.placeholder.com/20',
                            height: screenWidth * 0.05,
                            width: screenWidth * 0.05,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                          SizedBox(height: screenWidth * 0.012),
                          Text(
                            laptop.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenWidth * 0.012),
                          Text(
                            '₹${laptop.price}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.012),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: screenWidth * 0.04,
                              ),
                              Text(
                                ' 4.5',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.012),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => onAddToCart(laptop),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                ),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: screenWidth * 0.03),
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