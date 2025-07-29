import 'package:dartz/dartz.dart';
import 'package:test_app1/domain/failures/failures.dart';
import '../entities/top_products_response.dart';
import '../repositories/product_repository.dart';

class GetTopProductsUseCase {
  final ProductRepository repository;

  GetTopProductsUseCase(this.repository);

  Future<Either<Failure, TopProductsResponse>> call() async {
    return await repository.getTopProducts();
  }
} 