class Endpoints {
  static const String baseUrl = 'https://test.tradeasia.vn/';

  static const String topProducts = '${baseUrl}api/test/topProducts';
  static String productDetails(String id) => '${baseUrl}api/test/productDetails/$id';
}