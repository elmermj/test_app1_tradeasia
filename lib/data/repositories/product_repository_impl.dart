import 'package:dartz/dartz.dart';
import '../../domain/entities/top_products_response.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/failures/failures.dart';
import '../datasources/product_remote_data_source.dart';
import '../../utils/failure_handler.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TopProductsResponse>> getTopProducts() async {
    try {
      final result = await remoteDataSource.getTopProducts();
      return Right(result);
    } on Failure catch (e) {
      FailureHandler.logFailure(e, context: 'Repository');
      return Left(e);
    } catch (e, stackTrace) {
      final failure = FailureHandler.categorizeException(e, stackTrace);
      FailureHandler.logFailure(failure, context: 'Repository');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductDetailResponse>> getProductDetails(String productId) async {
    try {
      final result = await remoteDataSource.getProductDetails(productId);
      return Right(result);
    } on Failure catch (e) {
      FailureHandler.logFailure(e, context: 'Repository');
      return Left(e);
    } catch (e, stackTrace) {
      final failure = FailureHandler.categorizeException(e, stackTrace);
      FailureHandler.logFailure(failure, context: 'Repository');
      return Left(failure);
    }
  }
} 