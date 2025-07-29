import 'product.dart';

class TopProductsResponse {
  final bool status;
  final TopProductsData data;
  final String message;

  TopProductsResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory TopProductsResponse.fromJson(Map<String, dynamic> json) {
    return TopProductsResponse(
      status: json['status'] ?? false,
      data: TopProductsData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class TopProductsData {
  final TopProduct topProduct;

  TopProductsData({
    required this.topProduct,
  });

  factory TopProductsData.fromJson(Map<String, dynamic> json) {
    return TopProductsData(
      topProduct: TopProduct.fromJson(json['top_product'] ?? {}),
    );
  }
}

class TopProduct {
  final int currentPage;
  final List<Product> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<dynamic> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  TopProduct({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: json['links'] ?? [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
} 