import 'package:dartz/dartz.dart';
import '../entities/top_products_response.dart';
import '../entities/product_detail.dart';
import '../failures/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, TopProductsResponse>> getTopProducts();
  Future<Either<Failure, ProductDetailResponse>> getProductDetails(String productId);
} 