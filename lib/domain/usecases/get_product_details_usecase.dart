import 'package:dartz/dartz.dart';
import '../entities/product_detail.dart';
import '../repositories/product_repository.dart';
import '../failures/failures.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductDetailResponse>> call(String productId) async {
    return await repository.getProductDetails(productId);
  }
} 