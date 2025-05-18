class DashboardResponse {
  final List<Banners> bannerOne;
  final List<Category> categories;
  final List<Product> products;
  final List<Banners> bannerTwo;
  final List<Product> newArrivals;
  final List<Banners> bannerThree;
  final List<Product> categoriesListing;
  final List<Banners> topBrands;
  final List<Product> brandListing;
  final List<Product> topSellingProducts;
  final List<FeaturedLaptop> featuredLaptops;
  final List<Banners> upcomingLaptops;
  final List<Product> unboxedDeals;
  final List<Product> myBrowsingHistory;

  DashboardResponse({
    required this.bannerOne,
    required this.categories,
    required this.products,
    required this.bannerTwo,
    required this.newArrivals,
    required this.bannerThree,
    required this.categoriesListing,
    required this.topBrands,
    required this.brandListing,
    required this.topSellingProducts,
    required this.featuredLaptops,
    required this.upcomingLaptops,
    required this.unboxedDeals,
    required this.myBrowsingHistory,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      bannerOne: (json['banner_one'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e))
          .toList() ?? [],
      categories: (json['category'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList() ?? [],
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      bannerTwo: (json['banner_two'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e))
          .toList() ?? [],
      newArrivals: (json['new_arrivals'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      bannerThree: (json['banner_three'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e))
          .toList() ?? [],
      categoriesListing: (json['categories_listing'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      topBrands: (json['top_brands'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e))
          .toList() ?? [],
      brandListing: (json['brand_listing'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      topSellingProducts: (json['top_selling_products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      featuredLaptops: (json['featured_laptop'] as List<dynamic>?)
          ?.map((e) => FeaturedLaptop.fromJson(e))
          .toList() ?? [],
      upcomingLaptops: (json['upcoming_laptops'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e))
          .toList() ?? [],
      unboxedDeals: (json['unboxed_deals'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      myBrowsingHistory: (json['my_browsing_history'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
    );
  }
}
class Banners {
  final String banner;

  Banners({required this.banner});

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      banner: json['banner'] ?? json['icon'] ?? '',
    );
  }
}

class Category {
  final String label;
  final String icon;

  Category({required this.label, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class Product {
  final String icon;
  final String? offer;
  final String? brandIcon;
  final String label;
  final String? subLabel;

  Product({
    required this.icon,
    this.offer,
    this.brandIcon,
    required this.label,
    this.subLabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'] ?? '',
      offer: json['offer'],
      brandIcon: json['brandIcon'],
      label: json['label'] ?? '',
      subLabel: json['SubLabel'] ?? json['Sublabel'],
    );
  }
}

class FeaturedLaptop {
  final String icon;
  final String brandIcon;
  final String label;
  final String price;

  FeaturedLaptop({
    required this.icon,
    required this.brandIcon,
    required this.label,
    required this.price,
  });

  factory FeaturedLaptop.fromJson(Map<String, dynamic> json) {
    return FeaturedLaptop(
      icon: json['icon'] ?? '',
      brandIcon: json['brandIcon'] ?? '',
      label: json['label'] ?? '',
      price: json['price'] ?? '',
    );
  }
}